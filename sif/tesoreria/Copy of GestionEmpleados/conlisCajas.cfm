<cfparam name="Attributes.modo"		default="" 		type="String">
<cfparam name="Attributes.form"		default="form1" type="String">
<cfparam name="Attributes.value"	default="" 		type="String">
<cfparam name="Attributes.CFid"		default="" 		type="any">
<cfparam name="Attributes.Mcodigo"	default="" 		type="any">
<cfparam name="Attributes.lectu"	default="no" type="boolean">

	<cfset LvarModificable=''>
<cfif isdefined ('Attributes.modo') and Attributes.modo eq 'ALTA'>
	<cfset LvarModificable = 'S'>
</cfif>

<cfif isdefined ('Attributes.modo') and Attributes.modo eq 'CAMBIO'>
	<cfset LvarModificable = 'N'>
</cfif>

<cfif isdefined ('Attributes.value') and len(trim(Attributes.value)) gt 0>
	<cfset LvarCCHid=#Attributes.value#>
<cfelse>
	<cfset LvarCCHid=''>
</cfif>

<!---<cfif isdefined ('Attributes.CFid') and len(trim(Attributes.CFid)) gt 0>
	<cfset LvarCFid =#Attributes.CFid#>
<cfelse>
	<cfset LvarCFid=''>
</cfif>--->
<cfif isdefined ('Attributes.Mcodigo') and len(trim(Attributes.Mcodigo)) gt 0> 
	<cfset LvarM='and Mcodigo=#Attributes.Mcodigo#'>
<cfelse>
	<cfset LvarM=''>
</cfif>

<cfquery name="rsCajas" datasource="#session.dsn#">
	select CCHid,CCHcodigo,CCHdescripcion from CCHica where Ecodigo=#session.Ecodigo#
</cfquery>
		
				<cf_conlis title="LISTA DE CAJAS"
				campos = "CCHid, CCHcodigo, CCHdescripcion" 
				desplegables = "N,S,S" 
				modificables = "N,S,N" 
				size = "0,15,34"
				asignar="CCHid, CCHcodigo, CCHdescripcion"
				asignarformatos="S,S,S"
				tabla="CCHica"
				columnas="CCHid, CCHcodigo, CCHdescripcion"
				filtro="Ecodigo = #Session.Ecodigo# and CCHestado='ACTIVA' #LvarM# "
				desplegar=" CCHcodigo, CCHdescripcion"
				etiquetas=" C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				showEmptyListMsg="true"
				EmptyListMsg=""
				form="#Attributes.form#"
				width="800"
				height="500"
				left="70"
				top="20"
				filtrar_por="CCHcodigo, CCHdescripcion"
				index="1"		
				traerInicial="#LvarCCHid NEQ ''#"	
				traerFiltro="CCHid=#LvarCCHid#"
				funcion="funcCambiaValores"
				fparams="CCHid"
				readOnly="#Attributes.lectu#"
				/>        
				
		</td></strong>


<!---<script language="javascript1.1" type="text/javascript">

var popUpWinSN=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
  	}
  	popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	window.onfocus = closePopUp;
}

function doConlis(Aid,Inconsistencias){
<cfoutput>
	popUpWindow("/cfmx/sif/tesoreria/GestionEmpleados/CCHDtransacciones.cfm",350,250,800,500);
					
</cfoutput>
}

function closePopUp(){
	if(popUpWinSN) {
		if(!popUpWinSN.closed) popUpWinSN.close();
		popUpWinSN=null;
  	}
}--->

<!---function funcfiltro(){
<cfoutput>
	document.detAFVR.action='inconsistencias_form.cfm';
	document.detAFVR.submit();
</cfoutput>
}--->
