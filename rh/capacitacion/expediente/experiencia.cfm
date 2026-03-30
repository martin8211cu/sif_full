<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ExperienciaDel" Default="Experiencia del" returnvariable="LB_ExperienciaDel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Oferente" Default="oferente"  returnvariable="LB_Oferente" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>	
<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>	
<cfinvoke Key="LB_Actualmente" Default="Actualmente" returnvariable="LB_Actualmente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ExperienciaLaboral" Default="Experiencia laboral" returnvariable="LB_ExperienciaLaboral" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Deseable" default="Deseable"returnvariable="LB_Deseable" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Intercambiable" default="Intercambiable"returnvariable="LB_Intercambiable" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Requerido" default="Requerido"returnvariable="LB_Requerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ExperienciaRequerida" default="Experiencia Requerida" returnvariable="LB_ExperienciaRequerida" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="LB_ExperienciaDelOferente" Default="Experiencia del Oferente" returnvariable="LB_ExperienciaDelOferente" component="sif.Componentes.Translate" method="Translate" xmlfile="Expediente.xml"/>
<cfinvoke Key="LB_ExperienciaDelEmpleado" Default="Experiencia del Empleado" returnvariable="LB_ExperienciaDelEmpleado" component="sif.Componentes.Translate" method="Translate"/>
	
<cfset vstitulo =''>
<cfif isdefined("form.DEid")>
	<cfset vstitulo = LB_ExperienciaDelEmpleado>
<cfelseif isdefined("form.RHOid")>
	<cfset vstitulo = LB_ExperienciaDelOferente>
</cfif>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
	titulo='<cfoutput>#vstitulo#</cfoutput>'>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid>
		</cfif>
		<cfif isdefined("url.RHOid") and not isdefined("form.RHOid")>
			<cfset form.RHOid = url.RHOid>
		</cfif>
		<cfif isdefined("url.RHEEEid") and not isdefined("form.RHEEEid")>
			<cfset form.RHEEEid = url.RHEEEid>
		</cfif>
		<tr> 
			<td valign="top"> 
				<cfquery name="rsLista3" datasource="#session.DSN#">					
					select 	a.RHEEid,
							{fn concat(a.RHEEnombreemp,{fn concat(' - ',{fn concat(a.RHEEpuestodes,{fn concat(' - ',case <cf_dbfunction name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> when '01/01/6100' then '#LB_Actualmente#'else <cf_dbfunction name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> end)})})})} as descripcion,
							a.RHEEfechaini,
							a.RHEEfecharetiro,
							<cfif isdefined('Lvar_EducAuto')>
							 '7' as tab,	
							<cfelse>
							'3' as tab,	
							</cfif>	
							<cfif isdefined("form.DEid") and len(trim(form.DEid))>
								'#form.DEid#' as DEid,
							<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
								'#form.RHOid#' as RHOid,
							</cfif>
							2 as o, 1 as sel
							,a.RHEEestado 								
					from RHExperienciaEmpleado a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<cfif isdefined("form.DEid") and len(trim(form.DEid))>
							and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">	
						<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
							and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
						</cfif>
                            <cfif not isdefined('Lvar_EducAuto')>
                            and a.RHEEestado = 1
                            <cfelse>
                            and a.RHEEestado in(0,2)
                            </cfif>		
					Order by a.RHEEfecharetiro desc
				</cfquery>

				<cfif isdefined("form.DEid") and len(trim(form.DEid))>						
                	<cfif isdefined('Lvar_EducAuto')>
                    <cfset ira = "autogestion.cfm">
                    <cfelse>
					<cfset ira = "expediente.cfm">
                    </cfif>
				<cfelseif isdefined("form.RHOid") and len(trim(form.RHOid))>
					<cfset ira = "OferenteExterno.cfm">
				</cfif>
				
				<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista3#"/>
					<cfinvokeargument name="desplegar" value="descripcion"/>
					<cfinvokeargument name="etiquetas" value="#LB_ExperienciaLaboral#"/>
					<cfinvokeargument name="formatos" value="V"/>
					<cfinvokeargument name="align" value="left"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="irA" value="#ira#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="RHEEid"/>
					<cfinvokeargument name="formName" value="formExperienciaLista"/>
					<cfinvokeargument name="PageIndex" value="3"/>
				</cfinvoke>
			</td>
			<td width="55%">
				<cfinclude template="experiencia-form.cfm">
			</td>
		</tr>
		<cfif isdefined("form.DEid") and not isdefined('Lvar_EducAuto') and isdefined('otrosdatos.RHPcodigo')>
		<tr>
			<td colspan="2">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Experiencia_en_trabajos_anteriores"
				Default="Experiencia en trabajos anteriores"
				returnvariable="LB_Experiencia_en_trabajos_anteriores"/> 
	
				
				
				
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
					titulo='<cfoutput>#LB_ExperienciaRequerida#</cfoutput>'>
	
					<cfquery name="rsvalores" datasource="#session.dsn#">
						select	b.RHECGid, b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGid, c.RHDCGcodigo, c.RHDCGdescripcion,RHVPtipo,
							case RHVPtipo 
								when 10 then '#LB_Deseable#'
								when 20 then '#LB_Intercambiable#'
								when 20 then '#LB_Requerido#'
									else '' end as RHVPtipoDesc
							from RHValoresPuesto a
							inner join RHECatalogosGenerales b
								on a.RHECGid = b.RHECGid
							inner join RHDCatalogosGenerales c 
								on a.RHDCGid = c.RHDCGid
								and b.RHECGid = c.RHECGid
							inner join RHPuestos d
								on a.Ecodigo = d.Ecodigo
								and a.RHPcodigo = d.RHPcodigo
							inner join RHCalificacionExp e
								on c.RHECGid = e.RHECGid
							where coalesce(d.RHPcodigoext,d.RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#otrosdatos.RHPcodigo#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGcodigo, c.RHDCGdescripcion
					</cfquery>
					<table width="75%" cellpadding="3" cellspacing="0" align="center">
						<tr><td>&nbsp;</td></tr>
						<cfoutput query="rsvalores" group="RHECGid">
							<tr><td class="tituloListas">#RHECGdescripcion#</td></tr>
							<cfoutput>
								<tr><td <cfif rsvalores.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>#RHDCGdescripcion#&nbsp;&nbsp;
								  <cfif LEN(TRIM(RHVPtipo))>(#RHVPtipoDesc#)</cfif></td></tr>
							</cfoutput>					</cfoutput>
						<tr><td>&nbsp;</td></tr>
					</table>
					<cf_web_portlet_end>
			</td>
		</tr>
		<tr >
			<td colspan="2">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
					titulo='<cfoutput>#LB_Experiencia_en_trabajos_anteriores#</cfoutput>'>
						<cfinclude template="CalificaExperiencia.cfm">
				<cf_web_portlet_end>
			</td>
		</tr>
	</cfif>
		
		
	</table>		
<cf_web_portlet_end>
