<%@ page
	errorPage="error.jsp"
	contentType="text/html; charset=iso-8859-1" 
	import="dori.jasper.engine.*,
	dori.jasper.engine.util.*,
	dori.jasper.engine.export.*,
	java.math.BigDecimal,
	java.util.*,
	java.io.*,
	java.sql.*,
	javax.sql.*,
	javax.naming.*" %><%

Connection con = null;
try {


	java.util.Properties prop = new java.util.Properties();
	prop.put(javax.naming.Context.SECURITY_PRINCIPAL,   "guest");
	prop.put(javax.naming.Context.SECURITY_CREDENTIALS, "guest");
	javax.naming.InitialContext initContext = new javax.naming.InitialContext(prop);

	// obtener parametros del reporte de jdbc/PARAMS usando el id especificado en el url
	String FOidstr = request.getParameter("id");
	if (FOidstr == null || FOidstr.length() == 0) {
		throw new ServletException("Indique el reporte");
	}
	BigDecimal FOid = new BigDecimal(FOidstr);
	Object dsobject = initContext.lookup("java:comp/env/jdbc/PARAMS");
	if (dsobject == null || !( dsobject instanceof DataSource)) {
		throw new Exception("No se ha encontrado jdbc/PARAMS (ds == " + dsobject + ")");
	}
	DataSource ds = (DataSource) dsobject;
	con = ds.getConnection();
	if (con == null) {
		throw new Exception("No se ha definido jdbc/PARAMS (con == null)");
	}
	PreparedStatement ps = con.prepareStatement("select FOxml from ReporteFO where FOid = ?");
	ps.setBigDecimal(1, FOid);
	ResultSet rs = ps.executeQuery();
	if (!rs.next()) {
		// El reporte id=" + FOid + " no existe o ya ha expirado
		// Apelamos al cache del browser
		response.setStatus(304); // Not modified
		return;
	}
	String a_args = rs.getString(1);
	if (a_args == null || a_args.length() < 5) {
		throw new Exception("El reporte id=" + FOid + " es invalido");
	}
	rs.close();
	ps.close();
	// asegurarse de que no se repita su ejecucion
	ps = con.prepareStatement("delete from ReporteFO where FOid = ?");
	ps.setBigDecimal(1, FOid);
	int rowsAffected = ps.executeUpdate();
	ps.close();
	con.close();
	con = null;
	
	// obtener reporte jasper y preparar ejecucion
	Properties props = new Properties();
	StringTokenizer st = new StringTokenizer(a_args,"&");
	while (st.hasMoreTokens()) {
		String token = st.nextToken();
		int pos = token.indexOf("=");
		if ( pos != -1 ) {
			String name  = java.net.URLDecoder.decode( token.substring(0,pos));
			String value = java.net.URLDecoder.decode( token.substring(pos+1));
			if (name.length() > 0 && value.length() > 0) {
				props.setProperty (name, value);
			}
		}
	}
	
	String
		a_context = props.getProperty("CONTEXT_ROOT"),
		a_file = props.getProperty("JASPER_FILE"),
		a_datasource = props.getProperty("DATASOURCE"),
		a_type = props.getProperty("OUTPUT_FORMAT", "html");
	
	ServletContext servletContext = application;
	if (a_context != null && a_context.length() > 0) {
		servletContext = application.getContext(a_context);
		if (servletContext == null) {
			throw new Exception ("No se puede obtener el servlet context '" + a_context + "'");
		}
	}
	if (a_file == null || a_file.length() == 0) {
		throw new Exception("No se ha suministrado el nombre del archivo .jasper");
	}
	if (!a_type.equals("pdf") && !a_type.equals("html") &&
		!a_type.equals("xls") && !a_type.equals("csv")) {
		throw new Exception("El tipo de archivo solicitado no es valido");
	}

	String filename = servletContext.getRealPath(a_file);
	File reportFile = new File(filename);
	if (!reportFile.exists()) {
		throw new Exception("El archivo " + reportFile.getCanonicalFile() + " no existe");
	} else if (!reportFile.isFile()) {
		throw new Exception(reportFile.getCanonicalFile() + " no es un archivo normal");
	}
	JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	JRParameter[] jrParameters = jasperReport.getParameters();

	// preparar argumentos del reporte
	Map arguments = new HashMap();
	java.text.SimpleDateFormat sdfTimestamp = new java.text.SimpleDateFormat("{'ts' ''yyyy-MM-dd HH:mm:ss''}");
	java.text.SimpleDateFormat sdfTime      = new java.text.SimpleDateFormat("{'t' ''HH:mm:ss''}");
	java.text.SimpleDateFormat sdfDate      = new java.text.SimpleDateFormat("{'d' ''yyyy-MM-dd''}");
	for (int i = 0; i < jrParameters.length; i++) {
		String name = jrParameters[i].getName();
		String value = props.getProperty( name );
		if (value != null) {
			// ver si es una fecha
			Object objValue;
			if (value.startsWith("{ts '") && value.endsWith("'}") && value.length() == 26) {
				objValue = sdfTimestamp.parse(value);
			} else if (value.startsWith("{t '") && value.endsWith("'}") && value.length() == 14) {
				objValue = sdfTime.parse(value);
			} else if (value.startsWith("{d '") && value.endsWith("'}") && value.length() == 16) {
				objValue = sdfDate.parse(value);
			} else {
				objValue = jrParameters[i].getValueClass().
					getConstructor(new Class[]{String.class}).newInstance(new Object[]{value});
			}
			arguments.put (name, objValue);
		}
	}
	
	if (a_datasource == null || a_datasource.length() == 0) {
		throw new Exception("No se ha definido un datasource");
	}
	dsobject = initContext.lookup("java:comp/env/jdbc/" + a_datasource);
	if (dsobject == null || !( dsobject instanceof DataSource)) {
		throw new Exception("No se ha encontrado la conexi&oacute;n '" + a_datasource + "'");
	}
	ds = (DataSource) dsobject;
	con = ds.getConnection();
	if (con == null) {
		throw new Exception("No se ha obtenido la conexi&oacute;n a la base de datos '"
			+ a_datasource + "'");
	}

	arguments.put("BaseDir", reportFile.getParentFile());
	
	// llenar reporte
	JasperPrint jasperPrint = 
		JasperFillManager.fillReport(
			jasperReport, 
			arguments, con);
			
	Map imagesMap = new HashMap();
	session.setAttribute("IMAGES_MAP", imagesMap);
	
	// exportar reporte
	JRExporter exporter = null;
	if (a_type.equals("pdf")) {
		exporter = new JRPdfExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, response.getOutputStream());
		response.setContentType("application/pdf");
	} else if (a_type.equals("xls")) {
		exporter = new JRXlsExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, response.getOutputStream());
		response.setContentType("application/vnd.ms-excel");
	} else if (a_type.equals("csv")) {
		exporter = new JRCsvExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, response.getOutputStream());
		response.setContentType("text/plain");
	} else {
		exporter = new JRHtmlExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_MAP, imagesMap);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "image.jsp?i=");
		exporter.setParameter(JRHtmlExporterParameter.BETWEEN_PAGES_HTML, "<br style='page-break-after:always'>");
		exporter.setParameter(JRExporterParameter.OUTPUT_WRITER, out);
	}
	
	exporter.exportReport();
} catch (Throwable t) {
	t.printStackTrace();
	%> Error:<br><%= t %><br><b>Detalles: </b><br><xmp> <%
	t.printStackTrace(new PrintWriter(out));
	%> </xmp> <%
} finally {
	try { if (con != null) con.close(); } catch (Exception ignored) {}
}

%>