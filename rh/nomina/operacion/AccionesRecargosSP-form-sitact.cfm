<cfquery name="rsEVfantig" datasource="#Session.DSN#">
	select b.EVfantig
	from RHAcciones  a
	inner join EVacacionesEmpleado  b
		on  a.DEid = b.DEid
	where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif RHTcomportam eq 11> <!--- antigüedad --->
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		  <tr>
			<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Actual">Situaci&oacute;n Actual</cf_translate></div></td>
		  </tr>
		  <tr>
			<td height="25"   width="10%" class="fileLabel" nowrap><cf_translate key="LB_FechaAntiguiedad">Fecha de antig&uuml;edad</cf_translate></td>
			<td height="25" nowrap>#LSDateFormat(rsEVfantig.EVfantig, "dd/mm/yyyy")#</td>
		  </tr>
		</table>
	</cfoutput>
<cfelse> <!--- anotación --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Anotacion"
		Default="Anotaci&oacute;n"
		returnvariable="vAnotacion"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Tipo"
		Default="Tipo"
		xmlfile="/rh/generales.xml"
		returnvariable="vTipo"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha"
		Default="Fecha"
		xmlfile="/rh/generales.xml"
		returnvariable="vFecha"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Positiva"
		Default="Positiva"
		returnvariable="vPositiva"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Negativa"
		Default="Negativa"
		returnvariable="vNegativa"/>

	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		  <tr>
			<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Actual">Situaci&oacute;n Actual</cf_translate></div></td>
		  </tr>
		  <tr>
			<td   colspan="2" class="fileLabel" nowrap><cf_translate key="LB_Anotaciones">anotaciones</cf_translate></td>
		  </tr>
		  <tr>
			<td   colspan="2" >
				<cfquery name="rsLista" datasource="#session.DSN#">
					select 	<cf_dbfunction name="string_part"   args="b.RHAdescripcion,1,25">  as RHAdescripcionLS,
							b.RHAfecha as RHAfechaLS, 
							case when b.RHAtipo=1 then '#vPositiva#' when b.RHAtipo=2 then '#vNegativa#' end RHAtipoLS
					from RHAcciones  a
					inner join RHAnotaciones  b
						on  a.DEid = b.DEid
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					order by 2, 1

				</cfquery>				
				
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaFam">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="RHAdescripcionLS,RHAfechaLS,RHAtipoLS"/>
					<cfinvokeargument name="etiquetas" value="#vAnotacion#,#vFecha#,#vTipo#"/>
					<cfinvokeargument name="formatos" value="V,D,V"/>
					<cfinvokeargument name="align" value="left,left,center"/>
					<cfinvokeargument name="showLink" value="false"/>			
					<cfinvokeargument name="incluyeForm" value="false"/>
				</cfinvoke>	
			</td>
		  </tr>
		</table>
	</cfoutput>
</cfif>
