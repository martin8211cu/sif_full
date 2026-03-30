<!---
<cfquery name="def" datasource="asp">
	select -1 as Mcodigo
</cfquery>
--->
<cfset def = QueryNew("Mcodigo")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.FechaSugTC" default="" type="String"> <!--- Fecha para sugerir el tipo de cambio --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.Conlis" default="N" type="String"> <!--- Si es conlis 'S' o no 'N' --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.Mcodigo" default="Mcodigo" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.Mnombre" default="Mnombre" type="string"> <!--- Nombre de la descripción de la moneda --->
<cfparam name="Attributes.Miso4217" default="Miso4217" type="string"> <!--- Nombre de la sigla de la moneda Ej: CRC (Costa Rica)--->
<cfparam name="Attributes.frame" default="frmonedas" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.cualTC" default="V" type="string"> <!--- Tipo cambio que devuelve: C es Compra, V es venta --->
<cfparam name="Attributes.TC" default="TC" type="string"> <!--- Nombre del campo hidden donde va a quedar el tipo de cambio, sino queda en TC --->
<cfparam name="Attributes.valueTC" default="" type="string"> <!--- valor del TC, útil principalmente en modo cambio --->
<cfparam name="Attributes.onChange" default="" type="string"> <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfif isdefined('Session.Ecodigo')>
	<cfparam name="Attributes.Ecodigo" default="#Session.Ecodigo#" type="String"> <!--- Empresa --->
<cfelse>
	<cfparam name="Attributes.Ecodigo" default="" type="String"> <!--- Empresa --->
</cfif>
<cfparam name="Attributes.CrearMoneda" default="true" type="boolean"> <!--- opcioón de crear nueva moneda --->

<cfif Len(Trim(Attributes.Ecodigo)) EQ 0>
	<cfabort>
</cfif>
 

<!--- variables --->
<cfset vieneFecha = false >

<!--- validar parámetros --->
<cfif Len(Trim(Attributes.FechaSugTC)) GT 0 >	
	<cfif LSIsDate('#Attributes.FechaSugTC#')>
		<cfset vieneFecha = true >
 		<cfquery name="TCsug" datasource="#Attributes.Conexion#">
			select tc.Mcodigo, tc.TCcompra, tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = <cfqueryparam value="#Attributes.Ecodigo#" cfsqltype="cf_sql_integer">
			  and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Attributes.FechaSugTC)#">
			  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Attributes.FechaSugTC)#">
		</cfquery>
	</cfif>	
</cfif>

<cfif Len(Attributes.cualTC) GT 0 >	
	<cfif Trim(Attributes.cualTC) EQ "C"> <cfset TC = "TCcompra"> <cfelse> <cfset TC = "TCventa"></cfif>	
</cfif>


<!--- consultas --->
<cfif Attributes.Conlis NEQ "S">
	<cfquery name="rsMonedas" datasource="#Attributes.Conexion#">
		select convert(varchar,Mcodigo) as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
		from Monedas
		where Ecodigo = <cfqueryparam value="#Attributes.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset longitud = len(Trim(rsMonedas.Miso4217))>
</cfif>

<cfquery name="rsMonedaLocal" datasource="#Attributes.Conexion#">
	select Mcodigo from Empresas 
	where Ecodigo = <cfqueryparam value="#Attributes.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
<script language="JavaScript">
function UpperCase(Obj){
	if(Obj.name) {	
		if(Obj.value!="")
			Obj.value=Obj.value.toUpperCase();		
		return;
	}
	else
		return Obj.toUpperCase();	 
}

var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
	if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlis<cfoutput>#Attributes.Mcodigo#</cfoutput>() {
	var params ="";
	params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.Mcodigo#&desc=#Attributes.Mnombre#&fmt=#Attributes.Miso4217#</cfoutput>";
	popUpWindow("/cfmx/sif/Utiles/ConlisMonedas.cfm"+params,250,200,450,350);
}


function TraeMoneda<cfoutput>#Attributes.Mcodigo#</cfoutput>(dato) {
	var params ="";
	params = "<cfoutput>&id=#Attributes.Mcodigo#&desc=#Attributes.Mnombre#&fmt=#Attributes.Miso4217#</cfoutput>";
	
	if (dato!="") {
		document.all["<cfoutput>#Attributes.frame#</cfoutput>"].src="/cfmx/sif/Utiles/sifmonedasquery.cfm?Miso4217="+dato+"&form="+'<cfoutput>#Attributes.form#</cfoutput>'+params;
	}
	
	return;
}

function crearNuevo<cfoutput>#Attributes.Mcodigo#</cfoutput>() {

	// si va a crear una nueva moneda
	if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.value == "0") {
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.selectedIndex = 0;
		//alert('Vamos a crear una nueva moneda');
		location.href='/cfmx/sif/ad/catalogos/Monedas.cfm';
		return;
	}
	else 
		// no hace nada es solo un separador
		if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.value == "")  {
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.selectedIndex = 0;
			return;
		}
}

function validatc<cfoutput>#Attributes.Mcodigo#</cfoutput>()
{	
   
	if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.value == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){								
		document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TC#</cfoutput>.value = "1.00";
	} 
	else{
		<cfif vieneFecha>
		<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
		//Verificar si existe en el recordset
		var nRows = rsTCsug.getRowCount();
		if (nRows > 0) {
			for (row = 0; row < nRows; ++row) {
				if (rsTCsug.getField(row, "Mcodigo") == document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.value) {
					document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TC#</cfoutput>.value = rsTCsug.getField(row, "<cfoutput>#TC#</cfoutput>");
					row = nRows;
				}
				else
					document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TC#</cfoutput>.value = "0.00";					
			}									
		}
		else 
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TC#</cfoutput>.value = "0.00";			
		<cfelse>
		;
		</cfif>
	}		
	
}


</script>

  <table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif Attributes.Conlis NEQ "S">
		<tr>		
			<td nowrap><cfoutput>					
			<select name="#Attributes.Mcodigo#" 
				id="#Attributes.Mcodigo#" <cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
			 <cfif vieneFecha>
			 	onChange="javascript:crearNuevo#Attributes.Mcodigo#(); validatc#Attributes.Mcodigo#();#Attributes.onChange#"				
			 <cfelse>
				onChange="javascript:crearNuevo#Attributes.Mcodigo#();#Attributes.onChange#"
			 </cfif>
				>
					</cfoutput>
					<cfoutput query="rsMonedas"> 
					  <option value="#rsMonedas.Mcodigo#"
 					   <cfif isdefined('Attributes.query') and ListLen('Attributes.query.columnList') GT 0 and #Attributes.query.Mcodigo# NEQ -1>
					  	<cfif rsMonedas.Mcodigo EQ Attributes.query.Mcodigo >selected
						<cfelseif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
 						</cfif>
						>						
						#rsMonedas.Mnombre#</option>
					</cfoutput>
					<cfif Attributes.CrearMoneda >
					  <option value="">-------------------</option>
					  <option value="0">Crear Nueva ...</option>											 				
					</cfif>
				</select>
			</td>
			<td nowrap>&nbsp;</td>
		</tr>
  	<cfelse>
		<cfoutput>
		<td nowrap>			
			<input type="text" name="#Attributes.Miso4217#" maxlength="3" size="3" onblur="javascript:UpperCase(this);TraeMoneda#Attributes.Mcodigo#(document.#Attributes.form#.#Evaluate('Attributes.Miso4217')#.value);" onfocus="javascript: this.select();"				
			value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Miso4217)#</cfif>">
		</td>
		
		<td nowrap>
			<input type="text" name="#Attributes.Mnombre#" maxlength="80" size="32" disabled
			value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Mnombre)#</cfif>">
			<cfif ucase(Attributes.Conlis) EQ "S">
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Monedas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlis#Attributes.Mcodigo#();'></a>		
			</cfif>			
		</td>		
		<input type="hidden" name="#Attributes.Mcodigo#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.query.Mcodigo)#</cfif>">			
		</cfoutput>
	</cfif>
	<cfoutput>
	<input type="hidden" name="#Attributes.TC#" value="<cfif isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1>#Trim(Attributes.valueTC)#</cfif>">						
	</cfoutput>
	<script language="JavaScript1.2"> </script>
  </table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="/cfmx/sif/Utiles/sifmonedasquery.cfm" ></iframe>

<script language="JavaScript1.2" type="text/javascript">

function sugerirTClocal<cfoutput>#Attributes.Mcodigo#</cfoutput>() {
	<cfif not (isdefined("Attributes.query") and ListLen(Attributes.query.columnList) GT 1)>
		if (document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.Mcodigo#</cfoutput>.value == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){								
			document.<cfoutput>#Attributes.form#</cfoutput>.<cfoutput>#Attributes.TC#</cfoutput>.value = "1.00";
		}
	</cfif> 
}	
</script>

<script language="JavaScript1.2" type="text/javascript">
	sugerirTClocal<cfoutput>#Attributes.Mcodigo#</cfoutput>();
</script>