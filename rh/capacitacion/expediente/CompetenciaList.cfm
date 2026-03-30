<cfquery name="rsfecha" datasource="#session.dsn#">
	select max(BMfecha) fecha  from  RHCompetenciasEmpleado
	<cfif isdefined("RHOid") and len(trim(RHOid))>
			where RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
	<cfelse>
		where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
	</cfif>
	and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery> 

<!---20140718 - ljimenez parametro para que solo captura del aNo en el registro de competencias--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
        ecodigo="#session.Ecodigo#" pvalor="2658" default="0" returnvariable="lvarSoloAnnoCompetencia"/>

<cf_dbfunction name="op_concat" returnvariable="_cat">

<cf_translatedata name="get" tabla="RHHabilidades" col="RHHdescripcion" returnvariable="LvarRHHdescripcion">
<cfquery name="rsH" datasource="#session.dsn#">
	select RHCEid,
			tipo,
			idcompetencia,
			#LvarRHHdescripcion# as descripcion,
			RHCEdominio  ,
			RHHcodigo Cod
			<cfif isdefined("DEid") and len(trim(DEid))>
				,coalesce(d.RHNcodigo#_cat#' - '#_cat#d.RHNdescripcion,'---') as RHNcodigo
			</cfif>,
			a.RHNid,
			coalesce(rhn.RHNcodigo#_cat#' - '#_cat# rhn.RHNdescripcion,'---') as RHNcodigoUser
            
            ,a.RHCEfdesde

            <cfif not #lvarSoloAnnoCompetencia#>
            	, a.RHCEfhasta
            </cfif>
	from RHCompetenciasEmpleado  a
		inner join RHHabilidades  b
			on a.idcompetencia = b.RHHid
			and a.Ecodigo = b.Ecodigo
			and coalesce(b.RHHinactivo,0) = 0
		<cfif isdefined("DEid") and len(trim(DEid))>
			left outer join RHHabilidadesPuesto c
				on b.RHHid = c.RHHid
				and b.Ecodigo = c.Ecodigo
				and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#puesto.RHPcodigo#">
			
				left outer join RHNiveles d
					on c.RHNid = d.RHNid
		</cfif>		
		left join RHNiveles rhn
					on a.RHNid = rhn.RHNid
			
	<cfif isdefined("RHOid") and len(trim(RHOid))>
		where RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
	<cfelse>
		where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
	</cfif>
		and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  tipo = 'H'
		and a.RHCEfdesde >= (select max(B.RHCEfdesde) from RHCompetenciasEmpleado B 
							<cfif isdefined("RHOid") and len(trim(RHOid))>
								where B.RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
							<cfelse>
								where B.DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
							</cfif>
							and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and   B.Ecodigo = a.Ecodigo 
							and   B.tipo = 'H' 
							and   B.idcompetencia = a.idcompetencia )		
		/*and RHCEdominio = (select max(RHCEdominio) from RHCompetenciasEmpleado x
							where x.idcompetencia = b.RHHid)*/
		group by  	tipo,idcompetencia,RHHdescripcion,RHCEdominio,RHCEid,RHHcodigo
					<cfif isdefined("DEid") and len(trim(DEid))>
						,coalesce(d.RHNcodigo#_cat#' - '#_cat#d.RHNdescripcion,'---') 
					</cfif>
					,a.RHNid,rhn.RHNcodigo#_cat#' - '#_cat#rhn.RHNdescripcion
					<cfif isdefined("request.useTranslateData") and request.useTranslateData eq 1>
					,RHHdescripcion_#session.idioma#
					</cfif>
                     ,a.RHCEfdesde <cfif not #lvarSoloAnnoCompetencia#>, a.RHCEfhasta</cfif>
	order by #LvarRHHdescripcion#, a.RHCEfdesde
</cfquery>

<cf_translatedata name="get" tabla="RHConocimientos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
<cfquery name="rsC" datasource="#session.dsn#">
	select 	RHCEid ,tipo,idcompetencia, #LvarRHCdescripcion# as descripcion, RHCEdominio, RHCcodigo Cod
			<cfif isdefined("DEid") and len(trim(DEid))>
				, coalesce(e.RHNcodigo#_cat#' - '#_cat#e.RHNdescripcion, '---') as RHNcodigo
			</cfif>
			, coalesce(rhn.RHNcodigo#_cat#' - '#_cat#rhn.RHNdescripcion,'---') as RHNcodigoUser
			,A.RHNid
            ,A.RHCEfdesde
			<cfif not #lvarSoloAnnoCompetencia#>
            	, A.RHCEfhasta
			</cfif>
	from  RHCompetenciasEmpleado A
		inner join RHConocimientos C
			on A.idcompetencia = C.RHCid
			and A.Ecodigo = C.Ecodigo
			and coalesce(C.RHCinactivo,0) = 0
	
		<cfif isdefined("DEid") and len(trim(DEid))>
			left outer join RHConocimientosPuesto d
				on C.RHCid = d.RHCid
				and C.Ecodigo = d.Ecodigo
				and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#puesto.RHPcodigo#">
				
				left outer join RHNiveles e
					on d.RHNid = e.RHNid
		</cfif>
		left join RHNiveles rhn
					on A.RHNid = rhn.RHNid
		<cfif isdefined("RHOid") and len(trim(RHOid))>
			where RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
		<cfelse>
			where DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
		</cfif>
		and   A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  tipo = 'C'		
		and A.RHCEfdesde >= (select max(B.RHCEfdesde) from RHCompetenciasEmpleado B 
							<cfif isdefined("RHOid") and len(trim(RHOid))>
								where B.RHOid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#"> 
							<cfelse>
								where B.DEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
							</cfif>
							and   B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and   B.Ecodigo = A.Ecodigo 
							and   B.tipo = 'C' 
							and   B.idcompetencia = A.idcompetencia )
		group by  	tipo,idcompetencia,RHCdescripcion,RHCEdominio ,RHCEid,RHCcodigo
					<cfif isdefined("DEid") and len(trim(DEid))>
						,coalesce(e.RHNcodigo#_cat#' - '#_cat#e.RHNdescripcion, '---')
					</cfif>
					,A.RHNid,rhn.RHNcodigo#_cat#' - '#_cat#rhn.RHNdescripcion
					<cfif isdefined("request.useTranslateData") and request.useTranslateData eq 1>
					,RHCdescripcion_#session.idioma#
					</cfif>
                    ,A.RHCEfdesde 
                    <cfif not #lvarSoloAnnoCompetencia#>
                    	, A.RHCEfhasta
                   	</cfif>
	order by #LvarRHCdescripcion#, A.RHCEfdesde
</cfquery> 

<form name="formlista" method="post">
	<cfif isdefined('RHOid') and len(trim(RHOid))>
		<input type="hidden" name="RHOid" value="<cfoutput>#RHOid#</cfoutput>">
		<input type="hidden" name="o" value="5">
	<cfelse>
	 	<input type="hidden" name="DEID" id="DEID" value="<cfoutput>#DEid#</cfoutput>">
	</cfif>	
	<input type="hidden" name="EditaCompetencia" value="">
	<input type="hidden" name="tab" value="2">
	<input type="hidden" name="RHCEid">
	<input type="hidden" name="MODOC1" value="ALTA">
	<input type="hidden" name="ANOTA" value="S">
	<input type="hidden" name="TIPO" value="">
	<input type="hidden" name="idcompetencia" value="">
	<input type="hidden" name="idnivel" value="">
	<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		<tr>
			<td  colspan="7"class="tituloListas" align="left" nowrap><strong><cf_translate key="LB_FechaDeLaUltimaRevision">Fecha de última revisión</cf_translate> : <cfif rsfecha.recordcount gt 0><cfoutput><cf_locale name="date" value="#rsfecha.fecha#"/></cfoutput></cfif></strong></td>
		</tr>	
		<tr>
			<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
			<td class="tituloListas" align="left"><strong><cf_translate key="Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
            <td class="tituloListas" align="left"><strong><cf_translate key="Fdesde" XmlFile="/rh/generales.xml">Desde</cf_translate></strong></td>
            <cfif not #lvarSoloAnnoCompetencia#>
    	        <td class="tituloListas" align="left"><strong><cf_translate key="Fhasta" XmlFile="/rh/generales.xml">Hasta</cf_translate></strong></td>
	        </cfif>
            
			<cfif isdefined("DEid") and len(trim(DEid))>
				<td class="tituloListas" align="left" width="10%"><strong><cf_translate key="LB_NivelPuesto">Nivel (Puesto)</cf_translate></strong></td>
			</cfif>
			<td class="tituloListas" align="left" width="10%"><strong><cf_translate key="LB_NivelEmpleado">Nivel (Empleado)</cf_translate></strong></td>
			<td class="tituloListas" align="right" ><strong><cf_translate key="LB_Dominio" xmlFile="Expediente.xml">Dominio</cf_translate></strong></td>
			<td class="tituloListas" align="left" colspan="2" width="18" height="17" nowrap></td>
		</tr>
		
		<cfif rsH.recordcount gt 0>
			<tr>
				<td  colspan="5" align="left"><strong><cf_translate key="LB_Habilidades">Habilidades</cf_translate></strong></td>
			</tr>
			<cfoutput query="rsH">
				<tr <cfif isdefined("form.DEid") and len(trim(form.DEid))>style="cursor:pointer;"</cfif>
				class="<cfif rsH.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
				onmouseover="style.backgroundColor='##E4E8F3';" 
				onMouseOut="style.backgroundColor='<cfif rsH.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
				>
					
					<td><cfif isdefined("form.RHCEid") and form.RHCEid eq rsH.RHCEid><img border="0" src="/cfmx/rh/imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
					<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
						<td >#rsH.Cod#-#rsH.descripcion#</td>	
						<td  align="right" >#LSNumberFormat(rsH.RHCEdominio,'____.__')#&nbsp;%</td>
						<cfif not isDefined("Lvar_CompAuto")>
							<td onClick="javascript:Historia(#rsH.idcompetencia#,'#rsH.tipo#',#RHOid#);"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></td>	
						</cfif>
					<cfelse>
						<td onClick="javascript:editar(#rsH.RHCEid#,#DEID#,'#rsH.tipo#',#rsH.idcompetencia#);">#rsH.Cod#-#rsH.descripcion#</td>
                       
                        <cfif #lvarSoloAnnoCompetencia#>
                        	<td >#year(rsH.RHCEfdesde)#</td>	
                        </cfif>


                        <cfif not #lvarSoloAnnoCompetencia#>
                        	<td >#DateFormat(rsH.RHCEfdesde,'dd/mm/yyyy')#</td>	
                        	<td >#DateFormat(rsH.RHCEfhasta,'dd/mm/yyyy')#</td>		
                        </cfif>
                        
						<td onClick="javascript:editar(#rsH.RHCEid#,#DEID#,'#rsH.tipo#',#rsH.idcompetencia#);">#rsH.RHNcodigo#</td>
						<td onClick="javascript:editar(#rsH.RHCEid#,#DEID#,'#rsH.tipo#',#rsH.idcompetencia#);">#rsH.RHNcodigoUser#</td>
						<td  align="right" onClick="javascript:editar(#rsH.RHCEid#,#DEID#,'#rsH.tipo#',#rsH.idcompetencia#);">#LSNumberFormat(rsH.RHCEdominio,'____.__')#&nbsp;%</td>
						<cfif not isDefined("Lvar_CompAuto")>
							<td onClick="javascript:Historia(#rsH.idcompetencia#,'#rsH.tipo#',#DEID#);"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></td>
						</cfif>
						<td onClick="javascript:editarCompetencia(#rsH.RHCEid#,#DEID#,'#rsH.tipo#',#rsH.idcompetencia#);"><img border="0" src="/cfmx/rh/imagenes/edit_o.gif" ></td>
					</cfif>	
				</tr>
			</cfoutput>
		<cfelse>
				<tr>
					<td  colspan="5" align="center"><strong><cf_translate key="LB_NoHayHabilidadesEnRegistro" xmlFile="Expediente.xml">No hay habilidades</cf_translate></strong></td>
				</tr>
		</cfif>
		<cfif rsC.recordcount gt 0>
			<tr>
				<td  colspan="5" align="left"><strong><cf_translate key="LB_Conocimientos" xmlFile="generales.xml">Conocimientos</cf_translate></strong></td>
			</tr>	 
			<cfoutput query="rsC">
				<tr <cfif isdefined("form.DEid") and len(trim(form.DEid))>style="cursor:pointer;"</cfif>
				class="<cfif rsC.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" 
				onmouseover="style.backgroundColor='##E4E8F3';" 
				onMouseOut="style.backgroundColor='<cfif rsC.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'"
				>
					<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
						<td><cfif isdefined("form.RHCEid") and form.RHCEid eq rsC.RHCEid><img border="0" src="/cfmx/rh/imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
						<td >#rsC.Cod#-#rsC.descripcion#</td>	
						<td align="right" >#LSNumberFormat(rsC.RHCEdominio,'____.__')#&nbsp;%</td>
						<cfif not isDefined("Lvar_CompAuto")>
							<td onClick="javascript:Historia(#rsC.idcompetencia#,'#rsC.tipo#',#form.RHOid#);"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></td>
						</cfif>
					<cfelse>
						<td><cfif isdefined("form.RHCEid") and form.RHCEid eq rsC.RHCEid><img border="0" src="/cfmx/rh/imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
						<td onClick="javascript:editar(#rsC.RHCEid#,#DEID#,'#rsC.tipo#',#rsC.idcompetencia#);">#rsC.Cod#-#rsC.descripcion#</td>
                        
                        <cfif #lvarSoloAnnoCompetencia#>
                        	<td >#year(rsC.RHCEfdesde)#</td>	
                        </cfif>
                        <cfif not #lvarSoloAnnoCompetencia#>
                        	<td >#DateFormat(rsC.RHCEfdesde,'dd/mm/yyyy')#</td>	
                        	<td >#DateFormat(rsC.RHCEfhasta,'dd/mm/yyyy')#</td>		
                        </cfif>

						<!--- *** ---><td onClick="javascript:editar(#rsC.RHCEid#,#DEID#,'#rsC.tipo#',#rsC.idcompetencia#);">#rsC.RHNcodigo#</td>
						<td onClick="javascript:editar(#rsC.RHCEid#,#DEID#,'#rsC.tipo#',#rsC.idcompetencia#);">#rsC.RHNcodigoUser#</td>
						<td align="right" onClick="javascript:editar(#rsC.RHCEid#,#DEID#,'#rsC.tipo#',#rsC.idcompetencia#);">#LSNumberFormat(rsC.RHCEdominio,'____.__')#&nbsp;%</td>
						<cfif not isDefined("Lvar_CompAuto")>
							<td onClick="javascript:Historia(#rsC.idcompetencia#,'#rsC.tipo#',#DEID#);"><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></td>
						</cfif>
						<td onClick="javascript:editarCompetencia(#rsC.RHCEid#,#DEID#,'#rsC.tipo#',#rsC.idcompetencia#);"><img border="0" src="/cfmx/rh/imagenes/edit_o.gif" ></td>
					</cfif>						
				</tr>
			</cfoutput>
		<cfelse>
				<tr>
					<td  colspan="5" align="center"><strong><cf_translate key="LB_NoHayConocimientosParaElEmpleado" xmlFile="Expediente.xml">No hay conocimientos para el empleado</cf_translate></strong></td>
				</tr>
		</cfif>	
				<tr>
					<td  colspan="7" align="center">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Agregar"
							Default="Agregar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Agregar"/>
							<cfoutput>
						<input type="button"  id="VERMANT" name="VERMANT" value="#BTN_Agregar#" onClick="AddMantenimiento();">
						</cfoutput>
					</td>
				</tr>		
	</table>
	

</form>

<script type="text/javascript" language="javascript1.2" >
	function editar(RHCEid,DEID,TIPO,idcompetencia){
		<cfif not isDefined("Lvar_CompAuto")>
			document.formlista.RHCEid.value = RHCEid;
			<cfif isdefined('RHOid') and len(trim(RHOid))>
				document.formlista.RHOid.value = DEID;
			<cfelse>
				document.formlista.DEID.value = DEID;
			</cfif>	
			
			document.formlista.TIPO.value = TIPO;
			document.formlista.idcompetencia.value = idcompetencia;
			document.formlista.MODOC1.value = 'ALTA';	
			document.formlista.submit();
		</cfif>
	}

	function editarCompetencia(RHCEid,DEID,TIPO,idcompetencia){
		document.formlista.RHCEid.value = RHCEid;
		<cfif isdefined('RHOid') and len(trim(RHOid))>
			document.formlista.RHOid.value = DEID;
		<cfelse>
			document.formlista.DEID.value = DEID;
		</cfif>	
		
		document.formlista.TIPO.value = TIPO;
		document.formlista.idcompetencia.value = idcompetencia;
		document.formlista.EditaCompetencia.value =1;
		document.formlista.MODOC1.value = 'CAMBIO';
		<cfif isDefined("Lvar_CompAuto")>
			document.formlista.tab.value = '8';	 
		</cfif>
		document.formlista.ANOTA.value = 'N';	 
		document.formlista.submit();
	}

	function Historia(idcompetencia,tipo,DEid){
		<cfset URLCompetenciaH = '/cfmx/rh/capacitacion/expediente/CompetenciaHistoria.cfm'>
		<cfif isdefined("Lvar_CompAuto") or isDefined("LvarAuto")>
			<cfset URLCompetenciaH = '/cfmx/rh/autogestion/operacion/CompetenciaHistoriaAuto.cfm'>
		</cfif>
		<cfif isdefined('form.RHOid') and len(trim(form.RHOid))>
			var PARAM  = "<cfoutput>#URLCompetenciaH#</cfoutput>?idcompetencia="+ idcompetencia + "&tipo=" + tipo+ "&RHOid=" + DEid
		<cfelse>
			var PARAM  = "<cfoutput>#URLCompetenciaH#</cfoutput>?idcompetencia="+ idcompetencia + "&tipo=" + tipo+ "&DEid=" + DEid
		</cfif>
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
</script>
