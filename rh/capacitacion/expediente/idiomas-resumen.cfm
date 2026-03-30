<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2725" default="0" returnvariable="LvarAprobarIdiomas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PendienteDeAprobacionRH" returnvariable="MSG_PendienteDeAprobacionRH" default="Pendiente de aprobación por RH" xmlFile="/rh/generales.xml">
<cfquery name="rsCUVitae" datasource="#session.DSN#">
	select a.RHOLengOral1, a.RHOLengOral2, a.RHOLengOral3, a.RHOLengOral4, a.RHOLengOral5, 
			a.RHOLengEscr1, a.RHOLengEscr2, a.RHOLengEscr3, a.RHOLengEscr4, a.RHOLengEscr5,
			a.RHOLengLect1, a.RHOLengLect2, a.RHOLengLect3, a.RHOLengLect4, a.RHOLengLect5,
			a.RHOIdioma1, a.RHOIdioma2, a.RHOIdioma3, a.RHOIdioma4, a.RHOOtroIdioma5,
			coalesce(a.RHOidiomaAprobado,0) as RHOidiomaAprobado
	from DatosOferentes a 
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	 <cfif not isdefined("LvarAuto") and LvarAprobarIdiomas><!---- mientras no sea autogestion se muestra unicamente los items aprobados---->
	 	and a.RHOidiomaAprobado=1
	 </cfif>
</cfquery>

<cfset t=createObject("component", "sif.Componentes.Translate")>
<cfset LB_NoSeEncontraronRegistros = t.translate('LB_NoSeEncontraronRegistros','No se encontraron registros','/rh/generales.xml')>
<cfset LB_Idiomas = t.translate('LB_Idiomas','Idiomas','/curriculumExt/curriculum.xml')>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="5" align="center"> 
	<cfif rsCUVitae.recordcount>
		<tr>
			<td><b><i class="fa fa-flag-checkered"></i><cf_Translate key="LB_Lenguaje" xmlFile="/curriculumExt/curriculum.xml">Lenguaje</cf_Translate></b></td>
			<td><b><i class="fa fa-group"></i><cf_Translate key="LB_DominioConversacional" xmlFile="/curriculumExt/curriculum.xml">Conversacional</cf_Translate></b></td>
			<td><b><i class="fa fa-pencil fa-fw"></i><cf_Translate key="LB_DominioEscrito" xmlFile="/curriculumExt/curriculum.xml">Escrito</cf_Translate></b></td>
			<td><b><i class="fa fa-book fa-fw"></i><cf_Translate key="LB_DominioLectura" xmlFile="/curriculumExt/curriculum.xml">Lectura</cf_Translate></b></td>
		</tr>	
		<cf_Translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
		<cfquery name="rsIdiomas" datasource="#session.DSN#">
			select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion 
			from RHIdiomas
			order by RHDescripcion asc
		</cfquery>
		<cfloop from="1" to="5" index="i">
			<cfset x='RHOIdioma#i#'>
			<cfif i eq 5>
				<cfset x='RHOOtroIdioma5'>
			</cfif>
			<cfif len(trim(evaluate("rsCUVitae."&x)))>
				<tr>
					<cfif i neq 5>
				 		<cfquery dbtype="query" name="nombreIdioma">
				 			select RHDescripcion from  rsIdiomas where RHIid = #evaluate("rsCUVitae."&x)#
				 		</cfquery>									
				 	<cfelse>	
				 		<cfquery datasource="#session.dsn#" name="nombreIdioma">
				 			select '#evaluate("rsCUVitae."&x)#' as RHDescripcion from dual
				 		</cfquery>
					</cfif>

					<td><strong>#nombreIdioma.RHDescripcion#</strong></td>
					<cfloop list="RHOLengOral,RHOLengEscr,RHOLengLect" index="j">
						<td>
							<cfif evaluate("rsCUVitae.#j##i#") eq 105>
								<cf_Translate key="LB_lenguamaterna" xmlFile="/curriculumExt/curriculum.xml">Lengua Materna</cf_Translate>
							<cfelse>	
								#evaluate("rsCUVitae.#j##i#")#%
							</cfif>									
						</td>
					</cfloop>
					<cfif rsCUVitae.RHOidiomaAprobado neq 1 and LvarAprobarIdiomas>
						<td><cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="1#i#" msg="#MSG_PendienteDeAprobacionRH#"></td>
					</cfif>
				</tr>
			</cfif>
		</cfloop>	
		<tr><td colspan="6">&nbsp;</td></tr>
	<cfelse>
		<tr>
			<td colspan="6" align="center">#LB_NoSeEncontraronRegistros#</td>
		</tr>			
	</cfif>
</table>
</cfoutput>