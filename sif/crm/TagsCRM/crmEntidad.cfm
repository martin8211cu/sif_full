<!--- 
Nota, cuando se pasa el parametro query este debe contener 4 campos
	*	CRMEid
	*	CRMEnombre	
	*	CRMEapellido1	
	*	CRMEapellido2		
	
		para armar el nombre de la entidad
--->

<cfquery name="def" datasource="sdc">
	select '' as RHPid
</cfquery>

<!--- Parámetros Generales --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la Conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del Form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- Consulta por Defecto --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- Tamaño del objeto de la Desripcion --->
<cfparam name="Attributes.Pdona" default="N" type="string"> <!--- Bandera para saber si la entidad permite donaciones --->

<!--- Nombres de los campos --->
<cfparam name="Attributes.CRMEid" default="CRMEid" type="string"> <!--- Nombre del Objeto CRMEid con el codigo de la Entidad  --->
<cfparam name="Attributes.CRMnombre" default="CRMnombre" type="string"> <!--- Nombre del Objeto donde se despliega el nombre --->

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.CRMEid#</cfoutput>(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) 
				popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}

	function doConlisEntidad<cfoutput>#Attributes.CRMEid#</cfoutput>() {
		var params = "";
		<cfoutput>
			params+= "?form=#Attributes.form#&conexion=#Attributes.conexion#";
			params+= "&CRMEid=#Attributes.CRMEid#&CRMnombre=#Attributes.CRMnombre#";			
			params+= "&CRMTEdonacion=#Attributes.Pdona#";
			popUpWindow#Attributes.CRMEid#("/cfmx/sif/crm/Utiles/ConlisEntidad.cfm"+params,250,200,650,400);
		</cfoutput>
	}
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset CodEntidad = "Trim('#Evaluate('Attributes.query.CRMEid')#')">
		<cfset NombreEnt = "Trim('#Evaluate('Attributes.query.CRMEnombre')#')">
		<cfset NombreApellido1Ent = "Trim('#Evaluate('Attributes.query.CRMEapellido1')#')">
		<cfset NombreApellido2Ent = "Trim('#Evaluate('Attributes.query.CRMEapellido2')#')">
	</cfif>
	<cfoutput>
		<input type="hidden" name="#Attributes.CRMEid#" id="#Attributes.CRMEid#" 
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#CodEntidad#')#</cfif>">
		<tr>
			<td nowrap>
				<input type="text"
					name="#Attributes.CRMnombre#" id="#Attributes.CRMnombre#"
					tabindex="-1" readonly="true"
					value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#NombreEnt#')# #Evaluate('#NombreApellido1Ent#')# #Evaluate('#NombreApellido2Ent#')#</cfif>" 
					size="#Attributes.size#" 
					maxlength="120">
				<a href="##" tabindex="-1"><img src="/cfmx/sif/crm/imagenes/Description.gif" alt="Lista de entidades" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisEntidad#Attributes.CRMEid#();'></a>
			</td>
		</tr>
	</cfoutput>
</table>