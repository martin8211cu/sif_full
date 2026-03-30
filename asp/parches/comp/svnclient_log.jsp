<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="org.tmatesoft.svn.core.*" %>
<%@ page import="org.tmatesoft.svn.core.wc.*" %>
<%@ page import="java.util.*" %>

<%

try{

	String svnURL = (String)request.getAttribute("svnurl");
	Date fecha_desde = (Date)request.getAttribute("fecha_desde");
	SVNClientManager cm = (SVNClientManager)request.getAttribute("svn_client_manager");
%>
svnURL = <%= svnURL %><br />
fecha_desde = <%= fecha_desde %><br />
cm = <%= cm %><br />
<%! Vector v = null; %>
<%
	SVNURL svnurlobj = SVNURL.parseURIDecoded(svnURL);
	String[] paths = new String[]{};
	boolean stopOnCopy = false;
	boolean reportPaths = true;
	SVNRevision startRevision = SVNRevision.create (fecha_desde);
	long limit = 10000;
	v = new Vector();
	ISVNLogEntryHandler loghandler = new ISVNLogEntryHandler()
		{
			public void handleLogEntry(SVNLogEntry logEntry) {
		          // Handles a log entry passed.
				  v.add(logEntry);
			}
		};

%><%= startRevision %><%
	/*
	 los parametros desde,hasta debe estar startRevision, HEAD
	 y no al revés para que no se haga bolas con las fechas
	*/
	cm.getLogClient().doLog (svnurlobj, null, SVNRevision.HEAD,
			startRevision, SVNRevision.HEAD,
			stopOnCopy, reportPaths, limit, loghandler);
	request.setAttribute("logresult", v);
}catch(Throwable t){
%><xmp><%
String msg = t.getMessage();
if (msg == null || msg.length() <= 10) {
	msg = t.toString();
}
request.setAttribute("logerror", t.getMessage());
}
%>
