<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NombreContacto" default = "Nombre del Contacto" returnvariable="LB_NombreContacto" xmlfile = "Contactos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Telefono" default = "Tel&eacute;fono" returnvariable="LB_Telefono" xmlfile = "Contactos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_PrimeroDebeIngresarLos" default = "Primero debe ingresar los" returnvariable="MSG_PrimeroDebeIngresarLos" xmlfile = "Contactos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DatosGenerales" default = "Datos Generales" returnvariable="MSG_DatosGenerales" xmlfile = "Contactos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DelSocioDeNegocios" default = "del Socio de Negocios" returnvariable="MSG_DelSocioDeNegocios" xmlfile = "Contactos.xml">


<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>

<table width="95%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td colspan="2" valign="top">
		<cfinclude template="../../portlets/pNavegacionAD.cfm">
	</td>
  </tr>

  <tr> 
	<td valign="top" width="50%"> <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="SNContactos"/>
		<cfinvokeargument name="columnas" value="SNcodigo, SNCcodigo as SNCcodigoLista, SNCnombre, SNCtelefono "/>
		<cfinvokeargument name="desplegar" value="SNCnombre, SNCtelefono"/>
		<cfinvokeargument name="etiquetas" value="#LB_NombreContacto#, #LB_Telefono#" />
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# 
								and SNcodigo=#Form.SNcodigo# 
								order by SNCnombre"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<!--- <cfinvokeargument name="incluyeform" value="false">
		<cfinvokeargument name="formname" value="listaContactos"/> --->
		 <cfinvokeargument name="irA" value="Socios.cfm?tab=4&modoC=CAMBIO"/> 
		<!--- <cfinvokeargument name="funcion" value="pantalla"/> --->
		<!--- <cfinvokeargument name="fparams" value=""/> --->
		<cfinvokeargument name="keys" value="SNCcodigoLista,SNcodigo"/>
	  </cfinvoke> </td>
	<td><cfinclude template="formContactos.cfm"> &nbsp;</td>
  </tr>
  <tr> 
	<td>&nbsp;</td>
	<td>&nbsp;</td>
  </tr>
</table>
<cfelse>
	<table align="center">
		<tr>
			<td>#LB_PrimeroDebeIngresarLos#&nbsp;<strong>#MSG_DatosGenerales#</strong>&nbsp;#MSG_DelSocioDeNegocios#</td>
		</tr>
	</table>
</cfif>