@Grapes([
    @Grab(group='org.jsoup', module='jsoup', version='1.11.2'),
    @Grab(group='xalan', module='xalan', version='2.7.2'),
    @Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7.1')

])


import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.nodes.Entities.EscapeMode
import javax.xml.transform.TransformerFactory
import javax.xml.transform.Transformer
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.stream.StreamSource
import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.ContentType.URLENC

/*
Extract - get the html and turn it into xhtml
 */
def html = 'https://example.com/some-page'.toURL().getText()

final def doc = Jsoup.parse(html)
doc.outputSettings().syntax(Document.OutputSettings.Syntax.xml)
doc.outputSettings().escapeMode(EscapeMode.xhtml)

/*
Transform - run it through an XSLT processor
 */
final def factory = TransformerFactory.newInstance()
def xformer = factory.newTransformer(new StreamSource('archetype1.xsl'))

def json = new ByteArrayOutputStream()
xformer.transform(new StreamSource(new ByteArrayInputStream(doc.toString().bytes)),
        new StreamResult(json))

System.out << json.toString()

/*
Load - import it into the JCR
 */
def http = new HTTPBuilder ('http://localhost:4502')
http.ignoreSSLIssues()
http.auth.basic 'admin', 'admin'



http.post( path: '/content/some/path',
           body: [
                ':operation': 'import',
                ':contentType': 'json',
                ':content': json.toString(),
                ':replace': 'true'
           ],
           requestContentType: URLENC) { resp ->
    assert resp.status == 200
}
