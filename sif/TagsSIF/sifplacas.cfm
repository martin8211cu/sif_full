<!---
<cfquery name="def" datasource="asp">
	select '' as Aplaca
</cfquery>
--->
<cfset def = QueryNew("Aplaca")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.Aid" default="Aid" type="string"> <!--- Nombres del código de la placa --->
<cfparam name="Attributes.Adescripcion" default="Adescripcion" type="string"> <!--- Nombres de la descripción de la placa --->
<cfparam name="Attributes.Aplaca" default="Aplaca" type="string"> <!--- Nombres de la sigla de la placa --->
<cfparam name="Attributes.frame" default="frplacas" type="string"> <!--- Nombre del frame --->

<!--- consultas --->
<cfset Mascara = "">
<cfset sizeMascara = 0 >

<cfquery name="rs" datasource="#Session.DSN#">
	select convert(varchar,a.Aid) as Aid, a.Adescripcion, a.Dcodigo, upper(rtrim(ltrim(a.Aplaca))) as Aplaca
	from Activos a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.Astatus = 0
</cfquery>

<cfquery name="rsMask" datasource="#Attributes.Conexion#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="250">
	  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="AF">
</cfquery>

<cfif rsMask.RecordCount GT 0 >
	<cfset Mascara = rsMask.Pvalor>
	<cfset sizeMascara = Len(Trim(Mascara)) >
</cfif>


<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
	if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlis<cfoutput>#Attributes.Aid#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.Aid#&desc=#Attributes.Adescripcion#&placa=#Attributes.Aplaca#</cfoutput>";
	popUpWindow("/cfmx/sif/af/consultas/ConlisActivosPlaca.cfm"+params,250,200,650,350);
}


function TraePlaca<cfoutput>#Attributes.Aid#</cfoutput>(dato) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Aid#&desc=#Attributes.Adescripcion#&placa=#Attributes.Aplaca#</cfoutput>";
	
	if (dato!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifplacasquery.cfm?Aplaca="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	
	return;
}

	// verifica que un caracter sea alfanumérico
	function esAlfanumerico(c) {
		var ok = false;
		// para establecer los rangos de las letras
		var A = "A";
		var Z = "Z"
		var a = "a"; 
		var z = "z";

		// para establecer los rangos de los números
		var cero = "0";
		var nueve = "9";

		if ( (c.charCodeAt(0) >= A.charCodeAt(0) && c.charCodeAt(0) <= Z.charCodeAt(0)) 
			|| (c.charCodeAt(0) >= a.charCodeAt(0) && c.charCodeAt(0) <= z.charCodeAt(0))
			|| (c.charCodeAt(0) >= cero.charCodeAt(0) && c.charCodeAt(0) <= nueve.charCodeAt(0))  
		)
			ok = true;	
		return ok;		
	}

	// valida el formato de la placa: recibe el obj a comparar con el formato y el separador del formato '-'	
	function validaFormato<cfoutput>#Attributes.Aid#</cfoutput>(obj,sep) {
		
		var sizeMask = document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>Mascara#Attributes.Aplaca#</cfoutput>.value.length;
		var ok = true;
				
		if (sizeMask == 0 ) {				
			alert("parece que no hay máscara definida");
			return false;
		}
		
		// el campo está vacío
		if (new Number(obj.value.length) == 0 ) {				
			return false;
		}
		// longitud del valor introducido == longitud de máscara
		if ( new Number(obj.value.length) == sizeMask) {

			for (var i = 0; i < sizeMask; i++) {
				// SI EL CARACTER ES ALFANUMERICO					
				if (esAlfanumerico(obj.value.charAt(i))) {
					if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>Mascara#Attributes.Aplaca#</cfoutput>.value.charAt(i) == sep) {	
						ok = false;						
						i = sizeMask;					
					}					
				}
				
				// SI EL CARACTER NO ES ALFANUMERICO
				else {
					if (obj.value.charAt(i) == sep) {
						if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>Mascara#Attributes.Aplaca#</cfoutput>.value.charAt(i) != obj.value.charAt(i)) {	
							ok = false;						
							i = sizeMask;														
						}										
					}
					else {
						ok = false;						
						i = sizeMask;																				
					}										
				}
			}
		}	
		else
			ok = false;
				
		if (!ok) {
			alert("¡Formato de placa incorrecto!");
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Aplaca#</cfoutput>.select();									
		}
		return ok;
	}

	function Limpiar<cfoutput>#Attributes.Aid#</cfoutput>() {
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Aid#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Adescripcion#</cfoutput>.disabled = false;
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Adescripcion#</cfoutput>.value = '';
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Adescripcion#</cfoutput>.disabled = true;
	}

</script>

<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<td nowrap>			
 		<input type="text" name="#Attributes.Aplaca#" maxlength="#sizeMascara#" size="#sizeMascara#" 
		onblur="javascript:if (validaFormato#Attributes.Aid#(this,'-')) TraePlaca#Attributes.Aid#(document.#Attributes.form#.#Evaluate('Attributes.Aplaca')#.value); else Limpiar#Attributes.Aid#();"		
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Aplaca)#</cfif>">
	</td>
	
	<td nowrap>
		<input type="text" name="#Attributes.Adescripcion#" maxlength="60" size="40" disabled
		value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Adescripcion)#</cfif>">
		<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Placas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlis#Attributes.Aid#();'></a>		
		<b>#Mascara#</b>
	</td>		
	<input type="hidden" name="#Attributes.Aid#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Aid)#</cfif>">			
	<input type="hidden" name="#Attributes.Aplaca#2" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Aplaca)#</cfif>">	
	<input type="hidden" name="Mascara#Attributes.Aplaca#" value="<cfoutput>#Trim(Mascara)#</cfoutput>">			
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="/cfmx/sif/Utiles/sifplacasquery.cfm" ></iframe>

