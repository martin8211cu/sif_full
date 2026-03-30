<%@ page
	errorPage="error.jsp"
	contentType="text/html; charset=iso-8859-1" 
	import="dori.jasper.engine.*,
	dori.jasper.engine.util.*,
	dori.jasper.engine.design.*,
	dori.jasper.engine.export.*,
	dori.jasper.engine.xml.JRXmlWriter,
	java.math.BigDecimal,
	java.util.*,
	java.util.Date,
	java.io.*,
	java.sql.*,
	javax.sql.*,
	javax.naming.*,
	java.awt.Color.*" %>
	<%!
		public JRDesignBand _createBand(int height, boolean splitAllowed){
			JRDesignBand _band = new JRDesignBand();
			_band.setHeight(height);
			_band.setSplitAllowed(splitAllowed);
			return _band; 
		}

		public JRDesignField _createField(String fieldName, String fieldTypeClassName){
			JRDesignField _field = new JRDesignField();
			_field.setName(fieldName);
			_field.setValueClassName(fieldTypeClassName);
			return _field;
		}	

		public JRDesignExpression _createExpression(String expressionType, String expressionText){
			JRDesignExpression _expression = new JRDesignExpression();
			_expression.setValueClassName(expressionType);
			_expression.setText(expressionText);
			return _expression;
		}	
		
		public JRDesignTextField _createTextField (
			float x, float y, float pancho, int alto,
			JRDesignExpression expression, JRDesignFont font,
			String expressionText, byte alinear, String pattern,
			int ajustex, int ajustey, boolean ajustar)
		{
			JRDesignTextField _textField =  new JRDesignTextField();
			int posx = (int) (cmToPixels(x)-ajustex);
			int posy = (int) (cmToPixels(y)-ajustey);
			int ancho = (int) cmToPixels(pancho);
			_textField.setX(posx);
			_textField.setY(posy);
			_textField.setTextAlignment(alinear);
			_textField.setWidth(ancho);
			_textField.setHeight(alto);
			_textField.setExpression(expression);
			_textField.setFont(font);
			_textField.setStretchWithOverflow(ajustar);
			_textField.setPattern(pattern);
			_textField.setBlankWhenNull(true);
			return _textField;
		}
		
		public JRDesignStaticText _createStaticField(float x, float y, float pancho, int alto, JRDesignFont font, String staticFieldText, byte alinear, int ajustex, int ajustey ){		
			JRDesignStaticText _staticField = new JRDesignStaticText();
			int posx = (int) (cmToPixels(x)-ajustex);
			int posy = (int) (cmToPixels(y)-ajustey);
			int ancho = (int) cmToPixels(pancho);
			_staticField.setX(posx);
			_staticField.setY(posy);
			_staticField.setTextAlignment(alinear);
			_staticField.setWidth(ancho);
			_staticField.setHeight(alto);
			_staticField.setFont(font);
			_staticField.setText(staticFieldText);
			return _staticField;
		}
		
		public JRDesignImage _createImageField(float x, float y, float pancho, float palto, int ajustex, int ajustey, String image ){
			JRDesignImage _imageField = new JRDesignImage();
			JRDesignExpression exImage = _createExpression("java.lang.String", image);
			int posx = (int) (cmToPixels(x)-ajustex);
			int posy = (int) (cmToPixels(y)-ajustey);
			int ancho = (int) cmToPixels(pancho);
			int alto = (int) cmToPixels(palto);
			_imageField.setExpression(exImage);
			_imageField.setScaleImage(JRImage.SCALE_IMAGE_FILL_FRAME); 
			_imageField.setX(posx);
			_imageField.setY(posy);
			_imageField.setWidth(ancho);
			_imageField.setHeight(alto);
			return _imageField;
		}

		public JRDesignFont _createFont(int size, boolean bold, boolean underline, boolean italic, String tipo ){
			// Revisando con Marcel encontramos que pdf aguanta Helvetica y Courier como tipos de letra
			// las otras no las soporto, por eso solo ponemos estas dos

			String tipoLetra = "Helvetica";
			if (tipo.compareTo("Courier") == 0){
				tipoLetra = "Courier";
			}

			JRDesignFont _font = new JRDesignFont();
			_font.setSize(size);
			_font.setBold(bold);
			_font.setUnderline(underline);
			_font.setItalic(italic);
			_font.setFontName(tipo);
			_font.setPdfFontName(tipoLetra);
			return _font;
		}

		public JRDesignLine _createLine(float x, float y, float pwidth, float pheight, int ajustex, int ajustey){
			JRDesignLine _line = new JRDesignLine();
			int posx = cmToPixels(x)-ajustex;
			int posy = cmToPixels(y)-ajustey;
			int width = cmToPixels(pwidth);
			int height = cmToPixels(pheight);
			_line.setX(posx);
			_line.setY(posy);
			_line.setWidth(width);
			_line.setHeight(height);
			_line.setPen(JRGraphicElement.PEN_THIN);
			_line.setStretchType(JRElement.STRETCH_TYPE_NO_STRETCH);
			_line.setFill(JRGraphicElement.FILL_SOLID);
			return _line;
		}

		public String typeClassName (int FMT10TIP) {
			return (FMT10TIP == 2) ? "java.util.Date" : (FMT10TIP == 1) ? "java.math.BigDecimal" : "java.lang.String";
		}
		
		public String validatePattern ( String FMT02FMT ) {
			if ( (FMT02FMT == null) || FMT02FMT.equals("-1")) {
				return null;
			} else {
				return FMT02FMT;
			}
		}

		public JRDesignParameter _createParameter(String name, int type){
			JRDesignParameter _parameter = new JRDesignParameter();
			String className = "java.lang.String";
			//className = ((type==1) ? "java.math.BigDecimal" : "java.lang.String");
			_parameter.setName(name);
			_parameter.setValueClassName(typeClassName(type));
			return _parameter;
		}

		public String SQLconfig(String tipo, String formato, String empresa){

			String sql = "select " +
		  		   " FMT02POS, FMT01LAR, FMT01ANC, FMT01ORI, FMT01LFT, FMT01TOP, FMT02LON, FMT02FMT, " +
				   " FMT01RGT, FMT01BOT, FMT02TPL, FMT02TAM, FMT02CLR, FMT02BOL, FMT02UND, FMT02AJU, " +
				   " FMT02ITA, FMT02JUS, FMT02TIP, FMT02FIL, FMT02COL, b.FMT02SQL, FMT02DES, c.FMT10TIP " +
				   " from FMT001 a " +
				   " 	inner join FMT002 b on a.FMT01COD=b.FMT01COD " +
				   " 	left  join FMT011 c on c.FMT00COD=a.FMT01TIP and c.FMT02SQL=b.FMT02SQL " +
				   " where a.FMT01COD = '"+formato+"' " +
				   "   and (a.Ecodigo is null or a.Ecodigo="+empresa + ")" +
				   "   and b.FMT02POS='" + tipo + "'" +
				   " order by 2, 1 ";
			return sql;
		}

		public boolean existField(JasperDesign jd, String fieldName, String FMT02SQL) throws javax.servlet.ServletException {
			if (fieldName == null) {
				throw new javax.servlet.ServletException("existField: Hay un fieldName en null, FMT02SQL = " + FMT02SQL);
			}
			java.util.Map mapFields = jd.getFieldsMap();
			if ( mapFields.containsKey(fieldName) ){
				return true;
			}
			return false;
		}
		
		public String getTypeField(JasperDesign jd, String fieldName) throws javax.servlet.ServletException{
			JRField field[] = jd.getFields(); 
			int i = 0;
			if (fieldName == null) {
				throw new javax.servlet.ServletException("getTypeField: Hay un fieldName en null");
			}
			while ( field != null && field[i] != null ){
				String fieldName_i = field[i].getName();
				if ( fieldName_i != null && fieldName_i.compareTo(fieldName) == 0 ){
					return field[i].getValueClassName();
				}
				i++;
			}
			throw new javax.servlet.ServletException("getTypeField: Hay un fieldName que no aparece: {" + fieldName + "}");
		}

		public int cmToPixels(float valor){
			float factor = (float) 28.35;    // 1cm = 28.3464567 pixeles
			return (int) (factor*valor);
		}
	%>
	<%
Connection con = null;
try {
	System.out.println(new Date() + ": crear reporte...");

// ***************************************************************
//								PENDIENTES
// ***************************************************************
//	1. La letra si varia desmadra el width de los inputs
//     del reporte. El height de cada campo esta en 14 pixeles
//	   no se como ajustarlo segun al tipo de letra y tamaño de la 
//     misma. La fuente pdf default es Helvetica.
// ***************************************************************
// Obtiene parametros de asp
// ***************************************************************
	// conexion
	// obtener parametros del reporte de jdbc/PARAMS usando el id especificado en el url
	String FOidstr = request.getParameter("id");
	if (FOidstr == null || FOidstr.length() == 0) {
		throw new ServletException("Indique el reporte");
	}
	BigDecimal FOid = new BigDecimal(FOidstr);

	java.util.Properties prop = new java.util.Properties();
	prop.put(javax.naming.Context.SECURITY_PRINCIPAL,   "guest");
	prop.put(javax.naming.Context.SECURITY_CREDENTIALS, "guest");
	javax.naming.InitialContext initContext = new javax.naming.InitialContext(prop);

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

	// out.println("debug: query 1");

	ResultSet rs = ps.executeQuery();
	if (!rs.next()) {
		%> La compilaci&oacute;n numero <%= FOid %> no existe o ha expirado <%
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

	String context = props.getProperty("CONTEXT_ROOT");
	String path = props.getProperty("CONTEXT_PATH");
	String FMT01COD = props.getProperty("FORMATO");
	String Ecodigo = props.getProperty("EMPRESA");
	int empresa = Integer.parseInt(Ecodigo);
	String conexion = props.getProperty("DATASOURCE");

// ***************************************************************
//  Obtiene el contexto
// ***************************************************************
	ServletContext servletContext = application;
	if (context != null && context.length() > 0) {
		servletContext = application.getContext(context);
		if (servletContext == null) {
			throw new Exception ("No se puede obtener el servlet context '" + context + "'");
		}
	}

//System.out.println(servletContext.getRealPath("/sif/reportes/"));

// ***************************************************************
// Establece conexión a la base de datos minisif, nacion, ... etc
// ***************************************************************
	//Object dsobject = initContext.lookup("java:comp/env/jdbc/"+conexion);
	dsobject = initContext.lookup("java:comp/env/jdbc/"+conexion);
	if (dsobject == null || !( dsobject instanceof DataSource)) {
		throw new Exception("No se ha encontrado jdbc/"+conexion+" (ds == " + dsobject + ")");
	}
	//DataSource ds = (DataSource) dsobject;
	ds = (DataSource) dsobject;
	con = ds.getConnection();
	if (con == null) {
		throw new Exception("No se ha definido jdbc/"+conexion+" (con == null)");
	}

// *************************************************************
// Variables Globales
// *************************************************************
	// fuente
	JRDesignFont letra = new JRDesignFont();
	String etiqueta = new String();
	boolean[] font_bold = {false, true};
	boolean[] ajustar = {false, true};
	byte[] alinear = {JRAlignment.HORIZONTAL_ALIGN_JUSTIFIED, JRAlignment.HORIZONTAL_ALIGN_LEFT,JRAlignment.HORIZONTAL_ALIGN_CENTER,JRAlignment.HORIZONTAL_ALIGN_RIGHT};
    	//String tipoDato[];
	String tipoDatoClassName;

	String fieldPattern = "";
	String nameField = "";
	String expresion = "";
	String FMT01SQL = "";

	// papel
	int papelAncho = 0;
	int papelLargo = 0;

	// variables para el calculo de dimensiones de cada banda
	int marginTop = 0;				// margen superior
	int marginBot = 0;				// margen inferior
	int marginLft = 20;				// margen izquierdo
	int marginRgt = 20;				// margen derecho
	int mindet  = 0;				// minimo 'Y' de detalle, convertido a pixeles
	int maxdet  = 0;				// maximo 'Y' de detalle, convertido a pixeles
	int anchoColumnHeader = 0;		// ancho de encabezado
	int anchoDetail       = 0;		// ancho del detalle ( espacio ocupado por el detalle )
	int anchoPageFooter   = 0;		// ancho de pie de pagina

	// reporte
	JasperDesign jasperDesign = new JasperDesign();
	jasperDesign.setName("Reporte");
	jasperDesign.setWhenNoDataType(JasperDesign.WHEN_NO_DATA_TYPE_ALL_SECTIONS_NO_DETAIL );

// *************************************************************
// Verificacion de datos de configuracion del reporte
// *************************************************************
	// recupera los sp para ejecutar
	String sql_sp =  " select FMT001.FMT01ANC, FMT001.FMT01LAR, FMT001.FMT01TOP, FMT001.FMT01BOT, FMT000.FMT01SQL " +
		   " from FMT001 join FMT000 on FMT001.FMT01TIP = FMT000.FMT00COD " +
		   " where (FMT001.Ecodigo is null or FMT001.Ecodigo=" + Ecodigo + ") and FMT001.FMT01COD='"+FMT01COD+"'" ;
	PreparedStatement ps_sp = con.prepareStatement(sql_sp);
	// out.println("debug: query 2");

	ResultSet rs_sp = ps_sp.executeQuery();	

	if (rs_sp.next()){

		FMT01SQL = rs_sp.getString("FMT01SQL");
		if (FMT01SQL == null  || FMT01SQL.length() == 0) {
			throw new ServletException("El SQL del reporte no esta correctamente definido");
		}

		if (rs_sp.getString("FMT01LAR") == null || rs_sp.getString("FMT01LAR").length() == 0) {
			throw new ServletException("El largo del papel no esta correctamente definido");
		}else{
			papelLargo = cmToPixels(rs_sp.getFloat("FMT01LAR"));
		}

		if (rs_sp.getString("FMT01ANC") == null || rs_sp.getString("FMT01ANC").length() == 0) {
			throw new ServletException("El ancho del papel no esta correctamente definido");
		}else{
			papelAncho = cmToPixels(rs_sp.getFloat("FMT01ANC"));
		}

		if (rs_sp.getString("FMT01TOP") == null || rs_sp.getString("FMT01TOP").length() == 0) {
			throw new ServletException("El margen superior no esta correctamente definido");
		}

		if (rs_sp.getString("FMT01BOT") == null || rs_sp.getString("FMT01BOT").length() == 0) {
			throw new ServletException("El margen inferior no esta correctamente definido");
		}
	}else{
		throw new ServletException("Error al consultar datos del formato!!");
	}

	// margenes superior e inferior
	marginTop = cmToPixels(rs_sp.getFloat("FMT01TOP"));
	marginTop = (marginTop==0) ? 30 : marginTop;
	marginBot = cmToPixels(rs_sp.getFloat("FMT01BOT"));
	marginBot = (marginBot==0) ? 30 : marginBot;

// **************************************0****************************
// parametros del reporte
// ******************************************************************
	String sql_par  = " select FMT010.FMT10PAR, FMT010.FMT10TIP, FMT010.FMT10DEF " +
		   " from FMT010 join FMT001 on FMT001.FMT01TIP = FMT010.FMT00COD " +
		   " where FMT001.FMT01COD='" + FMT01COD + "' ";
	PreparedStatement ps_par = con.prepareStatement(sql_par);
	// out.println("debug: query 3");

	ResultSet rs_parametros = ps_par.executeQuery();
	String report_query = FMT01SQL;
	
	while (rs_parametros.next()){
		String parameterName = rs_parametros.getString("FMT10PAR");
		String parameterSubstring = "#" + parameterName + "#";
		String parameterSubstring2 = "$P{" + parameterName + "}";
		int p = report_query.indexOf(parameterSubstring);
		int no_enciclarse = 50;
		while (p >= 0 && no_enciclarse--> 0) {
			report_query = report_query.substring (0, p) + parameterSubstring2 + report_query.substring(p+parameterSubstring.length());
			p = report_query.indexOf(parameterSubstring);
		}
		jasperDesign.addParameter(_createParameter(parameterName, rs_parametros.getInt("FMT10TIP")));
	}

// *************************************************************************
// Obtener etiquetas y ponerlas en un map con key:FMT02SQL, item:FMT11NOM
// *************************************************************************
	String sql_etiquetas =
		" select FMT011.FMT02SQL, FMT011.FMT11NOM " +
		" from FMT011 join FMT001 on FMT001.FMT01TIP = FMT011.FMT00COD " +
		" where FMT001.FMT01COD = '" + FMT01COD + "' ";

	PreparedStatement ps_etiquetas = con.prepareStatement(sql_etiquetas);
	// out.println("debug: query 4");

	ResultSet rs_etiquetas = ps_etiquetas.executeQuery();
	Properties etiquetas = new Properties();
	while (rs_etiquetas.next()) {
		String FMT02SQL = rs_etiquetas.getString("FMT02SQL");
		String FMT11NOM = rs_etiquetas.getString("FMT11NOM");
		// por si el FMT11NOM tiene caracteres invalidos
		FMT11NOM = FMT11NOM.replace(' ', '_').replace('-', '_').replace('.', '_').replace(',', '_');
		etiquetas.setProperty(FMT02SQL, FMT11NOM);
	}


// ******************************************************************
// Lineas del reporte
// ******************************************************************
	String sql_lin  = " select FMT09COL, FMT09FIL, FMT09HEI, FMT09WID " +
		   " from FMT009 " +
		   " where FMT01COD='"+FMT01COD+"'";
	PreparedStatement ps_lin = con.prepareStatement(sql_lin);
	// out.println("debug: query 5");

	ResultSet rs_lin = ps_lin.executeQuery();

// ******************************************************************
// Imagenes del reporte
// ******************************************************************
	String sql_img  = " select FMT03FIL, FMT03COL, FMT03ALT, FMT03ANC " +
		   " from FMT003 " +
		   " where FMT01COD='"+FMT01COD+"'";
	PreparedStatement ps_img = con.prepareStatement(sql_img);
	ResultSet rs_img = ps_img.executeQuery();

// ******************************************************************
// calculo de ancho del encabezado min(y del detalle) - margin top
// ******************************************************************
	String sql_mindet = "select min(FMT02COL) as FMT02COL" +
		   " from FMT002 " +
		   " where FMT01COD='"+FMT01COD+"'" +
		   " and FMT02POS='2'";
	PreparedStatement ps_mindet = con.prepareStatement(sql_mindet);
	// out.println("debug: query 6");

	ResultSet rs_mindet = ps_mindet.executeQuery();	 	   
	if  (rs_mindet.next()){
		mindet = cmToPixels(rs_mindet.getFloat("FMT02COL"));
		anchoColumnHeader = (mindet - marginTop);
		anchoColumnHeader = (anchoColumnHeader >= 0) ? anchoColumnHeader : 0;
	}

	String sql_maxdet = "select max(FMT02COL) as FMT02COL" +
		   " from FMT002 " +
		   " where FMT01COD='"+FMT01COD+"'" +
		   " and FMT02POS='2'";
	PreparedStatement ps_maxdet = con.prepareStatement(sql_maxdet);
	// out.println("debug: query 6");

	ResultSet rs_maxdet = ps_maxdet.executeQuery();	 	   
	if  (rs_maxdet.next()){
		maxdet = cmToPixels(rs_maxdet.getFloat("FMT02COL"));
	}

// ******************************************************************
// calculo de ancho del pageFooter - margin bot
// ******************************************************************
	String sql_minpdt = "select min(FMT02COL) as FMT02COL" +
		   " from FMT002 " +
		   " where FMT01COD='"+FMT01COD+"'" +
		   " and FMT02POS='3'";
	PreparedStatement ps_minpdt = con.prepareStatement(sql_minpdt);
	// out.println("debug: query 7");

	ResultSet rs_minpdt = ps_minpdt.executeQuery();	 	   

	String sql_maxpdt = "select max(FMT02COL) as FMT02COL" +
		   " from FMT002 " +
		   " where FMT01COD='"+FMT01COD+"'" +
		   " and FMT02POS='3'";
	PreparedStatement ps_maxpdt = con.prepareStatement(sql_maxpdt);
	// out.println("debug: query 8");

	ResultSet rs_maxpdt = ps_maxpdt.executeQuery();

	int minpdt = 0;
	if ( rs_minpdt.next() ){
		minpdt = cmToPixels(rs_minpdt.getFloat("FMT02COL"));
	}

	int maxpdt = 0;
	if ( rs_maxpdt.next() ){
		maxpdt = cmToPixels(rs_maxpdt.getFloat("FMT02COL"));
	}

	// el maximo Y y minimo Y del pageFooter es el mismo, pone un ancho fijo
	if ( maxpdt!=0 && minpdt!=0 && maxpdt==minpdt ){
		anchoPageFooter = 1;
	}
	else{
		anchoPageFooter = maxpdt - minpdt;
	}	
	anchoPageFooter = (anchoPageFooter > 0) ? anchoPageFooter+35 : 0;  // le hace un ajuste al ancho

// ******************************************************************
// calculo del espacio ocupado por el detalle
// ******************************************************************
	//anchoDetail = papelLargo - (marginTop+marginBot+anchoColumnHeader+anchoPageFooter);
	anchoDetail = maxdet - mindet + 24;
	anchoDetail = (anchoDetail >= 0) ? anchoDetail : 24;

System.out.print("anchoColumnHeader  "); System.out.println(anchoColumnHeader);
System.out.print("anchoDetail  "); System.out.println(anchoDetail);
System.out.print("anchoPageFooter  "); System.out.println(anchoPageFooter);

// *************************************************************
// Variable para imprimir page footer solo en la ultima pagina
// *************************************************************
	JRDesignVariable pfVariable = new JRDesignVariable(); 
	pfVariable.setName("IS_LAST_PAGE");
	pfVariable.setResetType(JRVariable.RESET_TYPE_NONE);
	pfVariable.setValueClassName("java.lang.Boolean");
	pfVariable.setInitialValueExpression(_createExpression("java.lang.Boolean", "Boolean.FALSE"));
	pfVariable.setExpression( _createExpression("java.lang.Boolean", "$V{IS_LAST_PAGE}") );
	jasperDesign.addVariable(pfVariable);

// *************************************************************
// parametros generales del reporte
// *************************************************************
	jasperDesign.setColumnCount(1);
	jasperDesign.setPrintOrder(JasperDesign.PRINT_ORDER_VERTICAL);
	jasperDesign.setOrientation(JasperDesign.ORIENTATION_PORTRAIT);
	jasperDesign.setPageWidth(papelAncho);
	jasperDesign.setPageHeight(papelLargo);
	jasperDesign.setTopMargin(marginTop);
	jasperDesign.setLeftMargin(marginLft);
	jasperDesign.setRightMargin(marginRgt);
	jasperDesign.setBottomMargin(marginBot);

// *************************************************************
// Define el sql para el reporte
// *************************************************************
	JRDesignQuery _query = new JRDesignQuery();
	_query.setText(report_query);
	jasperDesign.setQuery(_query);

// *************************************************************
// Define el ENCABEZADO
// *************************************************************
	String sql_enc = SQLconfig("1", FMT01COD, Ecodigo );
	PreparedStatement ps_enc = con.prepareStatement(sql_enc);
	// out.println("debug: query 9");

	ResultSet rs_enc = ps_enc.executeQuery();
	JRDesignBand columnHeaderBand = _createBand(anchoColumnHeader, true);

	while (rs_enc.next()){
		letra = _createFont(rs_enc.getInt("FMT02TAM"), rs_enc.getBoolean("FMT02BOL"), rs_enc.getBoolean("FMT02UND"), rs_enc.getBoolean("FMT02ITA"), rs_enc.getString("FMT02TPL") );
		
		if (rs_enc.getString("FMT02TIP").compareTo("2") == 0 ){
			// DATOS
			String FMT02SQL = rs_enc.getString("FMT02SQL");
			fieldPattern = validatePattern(rs_enc.getString("FMT02FMT"));
			nameField = etiquetas.getProperty(FMT02SQL);
			if ( ! existField(jasperDesign, nameField, FMT02SQL) ){
				jasperDesign.addField(_createField(nameField, typeClassName(rs_enc.getInt("FMT10TIP"))));
			}
			expresion = "$F{" + nameField + "}";
			columnHeaderBand.addElement( _createTextField(rs_enc.getFloat("FMT02FIL"), rs_enc.getFloat("FMT02COL"), rs_enc.getFloat("FMT02LON"), 14, _createExpression( typeClassName(rs_enc.getInt("FMT10TIP")) , expresion), letra, expresion, alinear[rs_enc.getInt("FMT02JUS")], fieldPattern, marginLft, marginTop, ajustar[rs_enc.getInt("FMT02AJU")] ) );
		}
		else{
			// ETIQUETAS
			etiqueta = rs_enc.getString("FMT02DES");
			columnHeaderBand.addElement( _createStaticField(rs_enc.getFloat("FMT02FIL"), rs_enc.getFloat("FMT02COL"), rs_enc.getFloat("FMT02LON"),14, letra, etiqueta, alinear[rs_enc.getInt("FMT02JUS")], marginLft, marginTop ) );
		}
	}
//			_staticField.setPrintWhenExpression(_createExpression("java.lang.Boolean", "new Boolean($V{REPORT_COUNT}.intValue() != 0)"));
	jasperDesign.setColumnHeader(columnHeaderBand);		// crea el Column Header


// *************************************************************
// Define el DETAIL (Detalle)
// *************************************************************
	String sql_det = SQLconfig("2", FMT01COD, Ecodigo  );
	PreparedStatement ps_det = con.prepareStatement(sql_det);
	// out.println("debug: query 10");

	ResultSet rs_det = ps_det.executeQuery();
	JRDesignBand detailBand = _createBand(anchoDetail, true);

	while (rs_det.next()){
		letra = _createFont(rs_det.getInt("FMT02TAM"), rs_det.getBoolean("FMT02BOL"), rs_det.getBoolean("FMT02UND"), rs_det.getBoolean("FMT02ITA"), rs_det.getString("FMT02TPL") );
		if (rs_det.getString("FMT02TIP").compareTo("2") == 0 ){
			// DATOS
			String FMT02SQL = rs_det.getString("FMT02SQL");
			fieldPattern = validatePattern(rs_det.getString("FMT02FMT"));
			nameField = etiquetas.getProperty(FMT02SQL);
			if ( ! existField(jasperDesign, nameField, FMT02SQL) ){
				jasperDesign.addField(_createField(nameField, typeClassName(rs_det.getInt("FMT10TIP"))));
			}
			expresion = "$F{" + nameField + "}";
			detailBand.addElement( _createTextField(rs_det.getFloat("FMT02FIL"), rs_det.getFloat("FMT02COL"), rs_det.getFloat("FMT02LON"), 14, _createExpression( typeClassName(rs_det.getInt("FMT10TIP")) , expresion), letra, expresion, alinear[rs_det.getInt("FMT02JUS")], fieldPattern, marginLft, anchoColumnHeader+marginTop, ajustar[rs_det.getInt("FMT02AJU")] ) );
		}
		else{
			// ETIQUETAS
			etiqueta = rs_det.getString("FMT02DES");
			detailBand.addElement( _createStaticField(rs_det.getFloat("FMT02FIL"), rs_det.getFloat("FMT02COL"), rs_det.getFloat("FMT02LON"),14, letra, etiqueta, alinear[rs_det.getInt("FMT02JUS")], marginLft, anchoColumnHeader+marginTop ) );
		}
		
	}
	// 			_staticField.setPrintWhenExpression(_createExpression("java.lang.Boolean", "new Boolean($V{REPORT_COUNT}.intValue() != 0)"));
	jasperDesign.setDetail(detailBand); 	// crea el detail

// **********************************************************************
// Truco para impresion de pagefooter en la ultima pagina (summary)
// **********************************************************************
	JRDesignBand summaryBand = _createBand(0, true);
	JRDesignLine linea = new JRDesignLine();
	linea.setDirection(JRLine.DIRECTION_BOTTOM_UP);
	linea.setHeight(10);
	linea.setWidth(5);
	linea.setX(10);
	linea.setY(10);
	linea.setPrintWhenExpression(_createExpression("java.lang.Boolean", "Boolean.FALSE); variable_IS_LAST_PAGE.setValue(Boolean.TRUE"));
	summaryBand.addElement(linea);
	jasperDesign.setSummary(summaryBand);

// **********************************************************************
// Define el PageFooter (PostDetalle), solo se imprimira al final
// **********************************************************************
	// crea la banda del posdetalle solo si se definieron datos para la banda
	String sql_pdt = SQLconfig("3", FMT01COD, Ecodigo );
	PreparedStatement ps_pdt = con.prepareStatement(sql_pdt);
	// out.println("debug: query 11");

	ResultSet rs_pdt = ps_pdt.executeQuery();

	JRDesignBand pageFooterBand = _createBand(anchoPageFooter, true);	// crea la banda
	// expresion para todos los campos del page footer
	JRDesignExpression pfexpression = new JRDesignExpression();
	pfexpression.setValueClassName("java.lang.Boolean");
	pfexpression.setText("$V{IS_LAST_PAGE}");

	while (rs_pdt.next()){
		letra = _createFont(rs_pdt.getInt("FMT02TAM"), rs_pdt.getBoolean("FMT02BOL"), rs_pdt.getBoolean("FMT02UND"), rs_pdt.getBoolean("FMT02ITA"), rs_pdt.getString("FMT02TPL") );
		if (rs_pdt.getString("FMT02TIP").compareTo("2") == 0 ) {
			// DATOS
			String FMT02SQL = rs_pdt.getString("FMT02SQL");
			fieldPattern = validatePattern(rs_pdt.getString("FMT02FMT"));
			nameField = etiquetas.getProperty(FMT02SQL);
			if ( ! existField(jasperDesign, nameField, FMT02SQL) ){
				jasperDesign.addField(_createField(nameField, typeClassName(rs_pdt.getInt("FMT10TIP"))));
			}
			expresion = "$F{" + nameField + "}";
			// dos lineas adicionales
			JRDesignTextField textField = _createTextField(rs_pdt.getFloat("FMT02FIL"), rs_pdt.getFloat("FMT02COL"), rs_pdt.getFloat("FMT02LON"), 14, _createExpression( typeClassName(rs_pdt.getInt("FMT10TIP")) , expresion), letra, expresion, alinear[rs_pdt.getInt("FMT02JUS")], fieldPattern, marginLft, minpdt, ajustar[rs_pdt.getInt("FMT02AJU")] );
			textField.setPrintWhenExpression(pfexpression);
			// fin dos lineas adicionales
			pageFooterBand.addElement( textField );
		}
		else{
			// ETIQUETAS
			etiqueta = rs_pdt.getString("FMT02DES");
			JRDesignStaticText staticField = _createStaticField(rs_pdt.getFloat("FMT02FIL"), rs_pdt.getFloat("FMT02COL"), rs_pdt.getFloat("FMT02LON"),14, letra, etiqueta, alinear[rs_pdt.getInt("FMT02JUS")], marginLft, minpdt );
			staticField.setPrintWhenExpression(pfexpression);
			pageFooterBand.addElement( staticField );
		}	
	}
	//		_staticField.setPrintWhenExpression(_createExpression("java.lang.Boolean", "new Boolean($V{REPORT_COUNT}.intValue() != 0)"));
	jasperDesign.setPageFooter(pageFooterBand);		// crea el Page Footer

// *************************************************************
// Lineas e Imagenes
// *************************************************************
	JRDesignBand backgroundBand = _createBand(papelLargo-marginTop-marginBot, true);	// crea la banda

	// lineas
	while ( rs_lin.next() ){
		backgroundBand.addElement( _createLine(rs_lin.getFloat("FMT09FIL"), rs_lin.getFloat("FMT09COL"), rs_lin.getFloat("FMT09WID"), rs_lin.getFloat("FMT09HEI"), marginLft, marginTop ) );
	}
	
	// imagenes
	int i = 1;
	while( rs_img.next() ){
		String imagen = "\"" + path + "i" + Ecodigo + "_" + FMT01COD +  "_" + String.valueOf(i) + ".gif" + "\"";
		backgroundBand.addElement( _createImageField(rs_img.getFloat("FMT03FIL"), rs_img.getFloat("FMT03COL"), rs_img.getFloat("FMT03ANC"), rs_img.getFloat("FMT03ALT"), marginLft, marginTop, imagen ) );
		i++;
	}

	jasperDesign.setBackground(backgroundBand);		// crea el background
// *************************************************************


// *************************************************************
// Compilar y generar Jasper
// *************************************************************

	String fileSeparator = System.getProperty("file.separator");
	String pathSeparator = System.getProperty("path.separator");
	String reportBaseName = Ecodigo + "_" + FMT01COD;
	String reportDir = servletContext.getRealPath("/sif/reportes");
	String base = application.getRealPath("/WEB-INF/lib/");
	if (!reportDir.endsWith(fileSeparator))
		reportDir += fileSeparator;
	if (!base.endsWith(fileSeparator))
		base += fileSeparator;
	System.setProperty("jasper.reports.compile.class.path", 
		base + "jasperreports-0.5.2.jar" + pathSeparator +
		base + "jasperreports-0.5.3.jar" + pathSeparator +
		base + "tools.jar");
	System.setProperty("jasper.reports.compile.temp",
		System.getProperty("java.io.tmpdir"));
	
	System.out.println(new Date() + ": compilar reporte...");

	// genera el .jasper y el .xml
	JasperManager jasperfile = new JasperManager();
	JRXmlWriter.writeReport(jasperDesign, reportDir + reportBaseName + ".xml", "iso-8859-1");
	jasperfile.compileReportToFile(jasperDesign, reportDir + reportBaseName + ".jasper");
	
	%><b>El reporte fue generado con &eacute;xito.</b> <br><a href="javascript:window.close();">Cerrar</a><%
} catch (Throwable t) {
	t.printStackTrace();
	String x = t.getMessage();
	%> <b>Error generando el reporte.</b> <br> <%= x %> <br><a href="javascript:window.close();">Cerrar</a>
	<a href="javascript:void((document.all?document.all.stacktrace:document.getElementById('stacktrace')).style.display='block');">Detalles</a>
<br><div id="stacktrace" style="display:none">
<xmp><% t.printStackTrace(new java.io.PrintWriter(out)); %></xmp>
	</div>
	
	<%
} finally {
	if (con != null) con.close(); 
}
%>
