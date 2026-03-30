<cfoutput>
	<cfset values = 0>
	<cfscript>
		function calculate ( input_text ) {
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
	<cfset formula = "x=5;resultado= x*round(10.58)">
	<cfset result = calculate("#formula#")>
	<cfset rs = result.get('resultado').toString()>
		<table align="center" border="0"><tr><td>
			El resultado  para la formula <strong>x=5;resultado= x*round(10.58)</strong> es <strong>#rs#</strong>
		</td></tr></table>

</cfoutput>
