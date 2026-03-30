<cfif isdefined("LvarPorCFuncional")>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CF">
<cfelse>
	<cfset LvarTipoDocumento = 0>
	<cfset LvarSufijoForm = "">
</cfif>
<cfif isdefined("LvarFiltroPorUsuario") and #LvarFiltroPorUsuario#>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CFusuario">
</cfif>

<cfinvoke key="LB_TituloListaDet" default="Detalle de la Solicitud de Pago Manual"	returnvariable="LB_TituloListaDet"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="LB_MontoSol" default="Monto Solicitado"	returnvariable="LB_MontoSol"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripción"	returnvariable="LB_Descripcion"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="LB_CentroFuncional" default="Centro<BR>Funcional"	returnvariable="LB_CentroFuncional"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="LB_Oficina" default="Oficina"	returnvariable="LB_Oficina"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="LB_Servicio" default="Servicio"	returnvariable="LB_Servicio"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="LB_CtaFinanciera" default="Cta. Financiera"	returnvariable="LB_CtaFinanciera"	method="Translate" component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>


<cfoutput><cfset titulo='#LB_TituloListaDet#'></cfoutput>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfquery datasource="#session.dsn#" name="listaDet">
		Select TESSPid,TESDPid,TESDPmontoSolicitadoOri, TESDPdescripcion,
				CFcuentaDB,cf.CFformato,cf.CFdescripcion,
				cfn.CFcodigo, o.Oficodigo
			<cfif isdefined("form.chkCancelados")>
				, 1 as chkCancelados
			</cfif>
				, TESDPdocumentoOri
				, cc.Ccodigo,
			CASE WHEN rt.Documento IS NOT NULL
                THEN '<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif''>'
                ELSE ''
			END CFDI
		  from TESdetallePago dp
			left outer join CFinanciera cf
				on cf.CFcuenta=dp.CFcuentaDB
				and cf.Ecodigo=dp.EcodigoOri
			left outer join CFuncional cfn
				inner join Oficinas o
					 on o.Ecodigo = cfn.Ecodigo
					and o.Ocodigo = cfn.Ocodigo
				on cfn.CFid=dp.CFid
			left outer join Conceptos cc
				on cc.Cid = dp.Cid
			left join (select distinct Documento from  CERepoTMP
						where Origen = 'TES'
			) rt
				on rt.Documento = dp.TESDPdocumentoOri
		  where EcodigoOri=#session.Ecodigo#
			and TESSPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>

	<cfif isdefined("LvarIncluyeForm") and LvarIncluyeForm>
		<cfset LvarIncluyeForm = "yes">
	<cfelse>
		<cfset LvarIncluyeForm = "no">
	</cfif>
	<cfif isdefined("LvarMnombreSP")>
		<cfoutput><cfset LvarMonedaTitulo = "#LB_MontoSol#<BR>#replace(LvarMnombreSP,",","","ALL")#"></cfoutput>
	<cfelse>
		<cfoutput><cfset LvarMonedaTitulo = "#LB_MontoSol#"></cfoutput>
	</cfif>

	<cfif isdefined("LvarPorCFuncional")>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#listaDet#"
			desplegar="TESDPdescripcion, CFcodigo, Oficodigo, Ccodigo, CFformato, TESDPmontoSolicitadoOri,CFDI"
			etiquetas="#LB_Descripcion#&nbsp;, #LB_CentroFuncional#&nbsp;, #LB_Oficina#&nbsp;,#LB_Servicio#&nbsp;,#LB_CtaFinanciera#,#LvarMonedaTitulo#"
			formatos="S,S,S,S,S,M,S"
			align="left,left,left,left,left,right,center"
			ira="solicitudesManual#LvarSufijoForm#.cfm"
			form_method="post"
			showEmptyListMsg="yes"
			keys="TESDPid"
			incluyeForm="#LvarIncluyeForm#"
			showLink="#LvarIncluyeForm#"
			maxRows="0"
		/>
	<cfelse>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#listaDet#"
			desplegar="TESDPdescripcion, Ccodigo, CFformato, TESDPmontoSolicitadoOri,CFDI"
			etiquetas="#LB_Descripcion#&nbsp;,#LB_Servicio#&nbsp;,#LB_CtaFinanciera#,#LvarMonedaTitulo#"
			formatos="S,S,S,M,S"
			align="left,left,left,right,center"
			ira="solicitudesManual.cfm"
			form_method="post"
			showEmptyListMsg="yes"
			keys="TESDPid"
			incluyeForm="#LvarIncluyeForm#"
			showLink="#LvarIncluyeForm#"
			maxRows="0"
		/>
	</cfif>

	<cf_web_portlet_end>
