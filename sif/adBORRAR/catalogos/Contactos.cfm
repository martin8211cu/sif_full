		
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
		<cfinvokeargument name="etiquetas" value="Nombre del Contacto, Teléfono" />
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
			<td>Primero&nbsp;debe&nbsp;ingresar&nbsp;los&nbsp;<strong>Datos&nbsp;Generales</strong>&nbsp;del&nbsp;Socio&nbsp;de&nbsp;Negocios</td>
		</tr>
	</table>
</cfif>