<cfif isdefined("url.fCMScodigo") and len(url.fCMScodigo) and not isdefined("form.fCMScodigo")>
	<cfset form.fCMScodigo = url.fCMScodigo>
</cfif>
<cfif isdefined("url.fCMSnombre") and len(url.fCMSnombre) and not isdefined("form.fCMSnombre")>
	<cfset form.fCMSnombre = url.fCMSnombre>
</cfif>

<!---
			L I S T A   D E   S O L I C I T A N T  E S
--->
<br>
<script language="javascript" type="text/javascript">
	function funcNuevo(){
		document.formlista.OPT.value = 1;
	}
</script>

<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" >
<cfinclude template="solicitantes-Filto.cfm">

<cfquery name="rsTiposSolicitud" datasource="#session.dsn#">
	select CMSid, CMScodigo, CMSnombre, 1 as opt
	from CMSolicitantes a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined("form.fCMScodigo") and len(trim(form.fCMScodigo)) >
			and upper(CMScodigo) like  upper('%#form.fCMScodigo#%')
		</cfif>
		
		<cfif isdefined("form.fCMSnombre") and len(trim(form.fCMSnombre)) >
			and upper(CMSnombre) like  upper('%#form.fCMSnombre#%')
		</cfif>

	order by CMSid, CMSnombre
</cfquery>

<cfset navegacion = "">
<cfif isdefined("form.fCMScodigo") and len(trim(form.fCMScodigo)) >
	<cfset navegacion = navegacion & "&fCMScodigo=#form.fCMScodigo#">
</cfif>
<cfif isdefined("form.fCMSnombre") and len(trim(form.fCMSnombre)) >
	<cfset navegacion = navegacion & "&fCMSnombre=#form.fCMSnombre#">
</cfif>

<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsTiposSolicitud#"/> 
	<cfinvokeargument name="desplegar" value="CMScodigo, CMSnombre"/> 
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Nombre"/> 
	<cfinvokeargument name="formatos" value="S,S"/> 
	<cfinvokeargument name="align" value="left,left"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="solicitantes.cfm"/> 
	<cfinvokeargument name="keys" value="CMSid"/> 
	<cfinvokeargument name="botones" value="Nuevo"/> 
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="formname" value="formlista"/> 
</cfinvoke> 