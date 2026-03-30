	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid>
		</cfif>
		<tr> 
			<td valign="top">
				<cfoutput>
				<form name="filtroEval" action="expediente.cfm" method="post" style="margin:0; ">
					<table width="100%" class="areaFiltro">
						<tr>
							<td width="1%"><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;</td>
							<td>
								<cfparam name="form.fFecha" default="">
								<cf_sifcalendario conexion="#session.DSN#" form="filtroEval" name="fFecha" value="#trim(form.fFecha)#">
							</td>
							<td><input type="submit" value="<cf_translate key='BTN_Filtrar'>Filtrar</cf_translate>"></td>
						</tr>
					</table>
					<input type="hidden" name="DEid" value="#form.DEid#">
					<input type="hidden" name="tab" value="7">
				</form>
				</cfoutput>
			 
				<cfquery name="rsListaCP" datasource="#session.DSN#">					
					select 	a.RHEEid, 
							a.RHEEdescripcion, 
							a.RHEEfecha, 
							a.RHEEfhasta, 
							a.RHEEfdesde, 
							a.PCid, 
							'#form.DEid#' as DEid,
							'7' as tab			

					from RHEEvaluacionDes a
					
					inner join RHListaEvalDes b
					on a.Ecodigo=b.Ecodigo
					and a.RHEEid=b.RHEEid
					and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					
					where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.RHEEestado=5
					<cfif isdefined("form.fFecha") and len(trim(form.fFecha))>
						and a.RHEEfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fFecha)#">
					</cfif>
					order by a.RHEEfdesde desc
				</cfquery>


			<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
				Default="Descripción" Key="LB_Descripcion" returnvariable="LB_Descripcion"/>	
			<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
				Default="Desde" Key="LB_Desde" returnvariable="LB_Desde"/>	
			<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
				Default="Hasta" Key="LB_Hasta" returnvariable="LB_Hasta"/>	
				
				<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsListaCP#"/>
					<cfinvokeargument name="desplegar" value="RHEEdescripcion,RHEEfdesde,RHEEfhasta"/>
					<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LB_Desde#,#LB_Hasta#"/>
					<cfinvokeargument name="formatos" value="V,D,D"/>
					<cfinvokeargument name="align" value="left,left,left"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="irA" value="expediente.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="RHEEid"/>
					<cfinvokeargument name="formName" value="formEProgLista"/>
					<cfinvokeargument name="PageIndex" value="7"/>
				</cfinvoke>
			</td>
			<td width="55%">
				<cfinclude template="evalProgramadas-form.cfm">
			</td>
		</tr>
	</table>		

