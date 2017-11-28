<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="text"/>

    <xsl:template match="/">
        {
            "page" : {
                "jcr:primaryType" : "cq:Page",
                "cq:template" : "some/template",
                "jcr:language" : "<xsl:value-of select="html/body/@class"/>",
                <xsl:apply-templates select="html/body/div/div/header"/>,
                <xsl:apply-templates select="html/body/div/div/main"/>
            }
        }
    </xsl:template>

    <xsl:template match="header">
        <xsl:apply-templates select="div[@class='subnav']"/>
    </xsl:template>

    <xsl:template match="div[@class='subnav']">
        "subnav": {
            "sling:resourceType" : "subnav/type",
        <xsl:apply-templates select="div/ul/li/a"/>
        }
    </xsl:template>

    <xsl:template match="main">
        "parsys" : {
            "sling:resourceType" : "components/foundation/parsys",
            <xsl:apply-templates select="section"/>
        }
    </xsl:template>

    <xsl:template match="li/a">
        "link<xsl:value-of select="position()"/>" : {
            "sling:resourceType" : "subnav/link/type",
            "url" : "<xsl:value-of select="@href"/>",
            "target" : "<xsl:value-of select="@target"/>",
            "dataExternal" : "<xsl:value-of select="@data-external"/>",
            "alt" : "<xsl:value-of select="@alt"/>",
            "text" : "<xsl:value-of select="."/>"
        }<xsl:if test="not(last() = position())">,</xsl:if>
    </xsl:template>

    <xsl:template match="section[@class='banner']">
        "banner<xsl:value-of select="position()"/>" : {
            "style" : "<xsl:value-of select="@style"/>", <xsl:comment>You'd need to parse the style elements.</xsl:comment>
            "image" : {
                "sling:resourceType" : "image/type",
                "fileReference" : "<xsl:value-of select="div/div/picture/img/@src"/>",
                "alt" : "<xsl:value-of select="div/div/picture/img/@alt"/>"
            }
        }
    </xsl:template>

    <xsl:template match="section[contains(@class, 'imageAndCopy')]">
        "callout<xsl:value-of select="position()"/>" : {
            "sling:resourceType" : "callout/type",
            "richtext" : "<xsl:apply-templates select="div/div[@class='copy']"/>"
        }

    </xsl:template>

    <xsl:template match="section"/>

    <xsl:template match="div[@class='copy']">
        <xsl:comment>Requires escaping if you are going to use html content</xsl:comment>
        <xsl:copy-of select="*" />
    </xsl:template>



</xsl:stylesheet>