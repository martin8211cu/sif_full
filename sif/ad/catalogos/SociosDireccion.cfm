<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 01 de marzo del 2006
	Motivo: Se agregó nuevo tab para  catalogo de Limite de credito adicional. 

	Modificado por Gustavo Fonseca Hernández
		Fecha: 28-6-2005.
		Motivo: Se agrega el campo SNDcodigo.
 --->		

<!---
<cfdump var="#form#">
<cfdump var="#url#" abort>
--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfoutput>#pNavegacion#</cfoutput>
		
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">	

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>		

<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>

	<cfif isdefined("url.tabs") and not isdefined("form.tabs")>
		<cfset form.tabs = url.tabs>
	</cfif>

	<cfif not ( isdefined("form.tabs") and ListContains('1,2,3,4', form.tabs) )>
		<cfset form.tabs = 1 >
	</cfif> 

	<cfif isdefined("url.SNcat") and not isdefined("form.SNcat")>
		<cfset form.SNcat = url.SNcat>
	</cfif>	
	
	<cfquery datasource="#session.dsn#" name="listaDirecciones">
		select
			(select sn.SNnombre
				from SNegocios sn
				where sn.Ecodigo = snd.Ecodigo
					and sn.SNcodigo = snd.SNcodigo) as NombreSocio,
			snd.id_direccion,
			snd.SNcodigo,
			snd.SNnombre,
			snd.SNDcodigo,
			case when <cf_dbfunction name="length"	args="ltrim(rtrim(d.direccion1))"> > 0 then d.direccion1 else d.direccion2 end as direccion1,
			case when snd.SNDfacturacion = 1 then 'X' else ' ' end as facturacion,
			case when snd.SNDenvio       = 1 then 'X' else ' ' end as envio,
			case when snd.SNDactivo      = 1 then 'X' else ' ' end as activo,
			snd.SNDlimiteFactura,
			de.DEnombre #_Cat# ' ' #_Cat# de.DEapellido1 #_Cat# ' ' #_Cat# de.DEapellido2 as nombre
		from SNDirecciones snd
			left join DatosEmpleado de
				on de.DEid = snd.DEid
			join DireccionesSIF d
				on snd.id_direccion = d.id_direccion
		where snd.Ecodigo=#session.Ecodigo# 
		  and snd.SNcodigo=#Form.SNcodigo# 
	</cfquery>
	
	<form name="listaDeDirecciones" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
		<td valign="top">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</td>
	  </tr>
	  <tr>
	  	<td align="center" class="tituloListas">
			<strong>Lista de Direcciones de <cfoutput>#listaDirecciones.NombreSocio#</cfoutput></strong>
		</td>
	  </tr>
	  <tr> 
		<td valign="top" width="150%">
		
			<cfset params="">
			<cfset params = params & "tab=8&modoC=CAMBIO">
			<cfif isdefined("form.SNcat")>
			<cfset params = params & "&SNcat=#form.SNcat#">
			</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#listaDirecciones#"
				desplegar="SNDcodigo, SNnombre, facturacion, envio, activo, SNDlimiteFactura, nombre"
				etiquetas="Código, Nombre, FC, EN, AC, Límite, Vendedor" 
				formatos="S,S,S,S,S,M,S"
				align="left, left, center, center, center, right, left"
				ajustar="S"
				Botones="Regresar,Nuevo"
				checkboxes="N"
				irA="SociosDirecciones_form.cfm?#params#" 
				keys="id_direccion,SNcodigo"
				pageindex="2"
				incluyeForm="false"
				formName="listaDeDirecciones"
				>
			</cfinvoke> 
		</td>
	  </tr>
	  <tr> 
		<td>&nbsp;</td>
	  </tr>
	</table> 
	<cfoutput>
		<script language="javascript" type="text/javascript">
			function funcRegresar(){
				<cfif isdefined("form.SNcat")>
					document.listaDeDirecciones.action="Socios.cfm?SNcodigo=#form.SNcodigo#";
				<cfelse>		
					document.listaDeDirecciones.action="listaSocios_Direcciones.cfm";
				</cfif>
				document.listaDeDirecciones.submit();
			}
			<!--- 2018-11-21 OPARRALES Valida form.SNcat --->
			<cfset varSNCat = 0>
			<cfif isdefined("form.SNcat")>
				<cfset varSNCat = form.SNCat>
			</cfif>

			function funcNuevo(){
				document.listaDeDirecciones.action="SociosDirecciones_form.cfm?SNcodigo=#form.SNcodigo#&SNCat=#varSNCat#&tab=8&id_direccion=&org=out"
			}

		</script>
	</cfoutput>
<cfelse>
	<table align="center">
		<tr>
			<td>Primero&nbsp;debe&nbsp;escoger&nbsp;el&nbsp;<strong>Socio&nbsp;de&nbsp;Negocios</strong></td>
		</tr>
	</table>
</cfif>
</form>
		
		<cf_web_portlet_end>	
<cf_templatefooter>