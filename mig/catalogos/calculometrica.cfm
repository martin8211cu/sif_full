<cfsetting requesttimeout="1800">


<!--- Funciones de Calculo --->
<cfscript>
	function calculate( input_text ) {
		var rdr = "";
		var parser = "";
		var m = "";
		calc_error = "";
		try {
			rdr = CreateObject("java", "java.io.StringReader");
			parser = CreateObject("java", "com.soin.rh.calculo.Calculator");
			rdr.init(input_text);
			parser.init(rdr);
			parser.parse();
			return parser.getSymbolTable();
		}
		catch(java.lang.Throwable excpt) {
			calc_error = excpt.Message;
		}
	}	
</cfscript>


<cffunction access="public" name="get_metricas" returntype="string" output="false">
	

	<cfinclude template="metricas_ret.cfm">
	

	<cfreturn metricas_ret>
</cffunction>
