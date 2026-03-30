<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ContabilizaNominaDesdeHistoricoDeNominas"
	Default="Contabiliza Nómina desde Histórico de Nóminas"
	returnvariable="LB_ContabilizaNominaDesdeHistoricoDeNominas"/> 	
	
	<cf_templatearea name="title">
		<cfoutput>#LB_RecursosHumanos#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="#LB_ContabilizaNominaDesdeHistoricoDeNominas#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cfquery name="pQuery" datasource="#Session.DSN#">
						select a.RCNid, rtrim(a.Tcodigo) as Tcodigo, a.RCDescripcion, a.RCdesde, a.RChasta, 
							b.Tdescripcion, c.CPcodigo
						from HRCalculoNomina a
							inner join TiposNomina b
								on a.Tcodigo = b.Tcodigo
								and a.Ecodigo = b.Ecodigo
							inner join CalendarioPagos c
								on a.RCNid = c.CPid
								and a.Ecodigo = c.Ecodigo	
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							and RCNid = #Arreglo[idx]#
							and IDcontable is null
							and RCestado > 2
						order by b.Tdescripcion
					</cfquery>
					<br>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td class="SubTitulo" align="center"><cf_translate  key="LB_ErroresContabilizandoHistoricoDeNominas">Errores Contabilizando Histórico de Nóminas</cf_translate></td>
					  </tr>
					</table>
					<cfoutput>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td><strong><cf_translate  key="LB_TipoDeNomina">Tipo de Nómina</cf_translate>
						&nbsp;:&nbsp;</strong></td>
						<td>#pQuery.Tdescripcion#</td>
						<td><strong><cf_translate  key="LB_CodigoCalendario">C&oacute;digo Calendario</cf_translate>&nbsp;:&nbsp;</strong></td>
						<td>#pQuery.CPcodigo#</td>
						<td><strong><cf_translate  key="LB_RelacionCalculo">Relación C&aacute;lculo</cf_translate>&nbsp;:&nbsp;</strong></td>
						<td>#pQuery.RCDescripcion#</td>
					  </tr>
					</table>
					</cfoutput>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Descripcion"
					Default="Descripción"
					returnvariable="LB_Descripcion"/> 
					
					<cfset navegacion = "">
					<cfif isdefined("form.btnContabilizar") and isdefined("form.chk") and len(form.chk)>
						<cfset navegacion = "&btnContabilizar=#form.btnContabilizar#&chk=#form.chk#">
					</cfif>

					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
						<cfinvokeargument name="query" value="#data#" />
						<cfinvokeargument name="desplegar" value="descripcion"/>
						<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
						<cfinvokeargument name="formatos" value="S"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="S" />
						<cfinvokeargument name="irA" value="contabilizaNominaH-sql.cfm" />
						<cfinvokeargument name="botones" value="Regresar" />
						<cfinvokeargument name="formName" value="form1" />
						<cfinvokeargument name="PageIndex" value="99" />
						<cfinvokeargument name="Navegacion" value="#navegacion#" />
						<cfinvokeargument name="showLink" value="false" />
					</cfinvoke>
					<br>				
				</td>
			</tr>
		</table>
		<cf_web_portlet_end>
	</cf_templatearea>
	<script language="javascript" type="text/javascript">
		function FuncRegresar(){
			document.href.location="contabilizaNominaH.cfm";
		} 
	</script>
	
</cf_template>