<cfif isdefined("form.btnSiguiente") or (isdefined("form.GrabarReasignar") and  form.GrabarReasignar EQ "1")>
	<cfif not isdefined("form.ID") or len(trim(form.ID)) EQ 0>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_NoSeHanAgregadoConcursantesParaLaAdjudicacionDePlazas" 
		Default="No se han agregado concursantes para la adjudicaci&oacute;n de plazas" returnvariable="MSG_NoSeHanAgregadoConcursantesParaLaAdjudicacionDePlazas"/>
		<cf_throw message="#MSG_NoSeHanAgregadoConcursantesParaLaAdjudicacionDePlazas#" errorcode="3045">
	<cfelse>
		<cfloop list="#form.ID#" index="i"><!---Se insertan todos los concursantes que fueron asignados a las plazas---->			
			<cfset t=#form.Tipo#>			
			<!--- CASO 1: BORRA LA PLAZA --->			
			<cfif isdefined("form._RHPid_#i#_I") and len(trim(form["_RHPid_#i#_I"])) and isdefined("form.RHPid_#i#_I") and not len(trim(form["RHPid_#i#_I"]))>	            	
				<cfquery datasource="#session.DSN#" name="rsI">
					delete from  RHAdjudicacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
					  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHCPid_#i#_I']#">
					  and RHAestado =0
				</cfquery>           
			</cfif>
			
			<cfif isdefined("form._RHPid_#i#_E") and len(trim(form["_RHPid_#i#_E"])) and isdefined("form.RHPid_#i#_E") and not len(trim(form["RHPid_#i#_E"]))>	
				<cfquery datasource="#session.DSN#">
					delete from RHAdjudicacion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
					  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHCPid_#i#_E']#">
					  and RHAestado =0
				</cfquery>
			</cfif>

			<cfif isdefined("form.RHPid_#i#_#t#") and len(trim(form["RHPid_#i#_#t#"]))>
					<cfquery name="rsPlaza" datasource="#session.DSN#"><!----Datos de la plaza---->
						select b.Ocodigo,b.Dcodigo,RHPpuesto
						from RHPlazas a
						inner join CFuncional b
							on b.CFid = a.CFid
							and b.Ecodigo = a.Ecodigo
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHPid_#i#_#t#']#">
					</cfquery>
					
					<cfquery name="rsSalario" datasource="#session.dsn#">
						select max(coalesce(b.RHMCmonto,0)) as SB
						from RHLineaTiempoPlaza lp
								inner join RHMontosCategoria b
								on lp.RHCid=b.RHCid
								inner join RHVigenciasTabla c
								on c.RHVTid = b.RHVTid
								and c.RHVTestado='A'
								and getdate() between RHVTfecharige and RHVTfechahasta
						where lp.RHPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHPid_#i#_#t#']#">
						<cfif isdefined('form.RHTTid') and len(trim(form.RHTTid)) gt 0>
							and c.RHTTid=#form.RHTTid#
						<cfelse>
							and c.RHTTid=(select min(RHTTid) from RHTTablaSalarial where Ecodigo = #session.Ecodigo#)
						</cfif> 
					</cfquery>
					
					<cfif isdefined('rsSalario') and len(trim(rsSalario.SB)) eq 0>
						<cfset LvarS=0>
					<cfelse>
						<cfset LvarS=#rsSalario.SB#>
					</cfif>				

					<!--- CASO 2: INSERTA LA PLAZA --->					
					<cfif isdefined("form.RHPid_#i#_#t#") and len(trim(form["RHPid_#i#_#t#"]))>
						<cfquery name="rs" datasource="#session.dsn#">
							select count(1) as cantidad from RHAdjudicacion
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHCconcurso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
							and RHCPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHCPid_#i#_#t#']#">
							<cfif isdefined("form.tipo_#i#_#t#") and len(trim(form["tipo_#i#_#t#"])) and form["tipo_#i#_#t#"] EQ 'I'>
								and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">							
							</cfif>
							<cfif isdefined("form.tipo_#i#_#t#") and len(trim(form["tipo_#i#_#t#"])) and form["tipo_#i#_#t#"] EQ 'E'>
								and RHOid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">									
							</cfif>
						</cfquery>
					
						<cfif rs.cantidad eq 0>
							<cfquery name="rsTabla" datasource="#session.dsn#">
								select coalesce(min(RHTTid),0) as RHTTid from RHTTablaSalarial where Ecodigo = #session.Ecodigo#
							</cfquery>
							<cfquery name="rsCodigo" datasource="#session.dsn#">	
								select min(Tcodigo) as Tcodigo from TiposNomina where Ecodigo=#session.Ecodigo#
							</cfquery>
							<cfquery datasource="#session.DSN#">
								insert into RHAdjudicacion(	Ecodigo, CEcodigo, RHCPid, RHCconcurso, DEid, RHOid, Ocodigo,
															Dcodigo, RHPid, RHPcodigo, RVid, Tcodigo, RHTid, RHJid, DLlinea,
															RHTCid, DLfvigencia, DLsalario, RHAporc, RHAporcsal, RHAestado, 
															BMUsucodigo,RHTTid)
								values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHCPid_#i#_#t#']#">,	
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
										<cfif isdefined("form.tipo_#i#_#t#") and len(trim(form["tipo_#i#_#t#"])) and form["tipo_#i#_#t#"] EQ 'I'>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">				
										<cfelse>
											null
										</cfif>,
										<cfif isdefined("form.tipo_#i#_#t#") and len(trim(form["tipo_#i#_#t#"])) and form["tipo_#i#_#t#"] EQ 'E'>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">				
										<cfelse>
											null
										</cfif>,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPlaza.Ocodigo#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPlaza.Dcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHPid_#i#_#t#']#">,
										<cfqueryparam cfsqltype="cf_sql_char" value="#rsPlaza.RHPpuesto#">,	
										null,'#rsCodigo.Tcodigo#',null,null,null,null,#now()#,#LvarS#,null,null,0,				
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
										<cfif isdefined('form.RHTTid') and len(trim(form.RHTTid)) gt 0>
										#form.RHTTid#
										<cfelse>
										#rsTabla.RHTTid#
										</cfif>  )								
							</cfquery>
						</cfif>
	
					<!--- CASO 3: MODIFICA LA PLAZA --->				
					<cfelseif isdefined("form._RHPid_#i#_#t#") and len(trim(form["_RHPid_#i#_#t#"])) and trim(form["_RHPid_#i#_#t#"]) neq trim(form["RHPid_#i#_#t#"])>
						<cfquery datasource="#session.DSN#">
							update RHAdjudicacion
							set RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHPid_#i#_I']#">,
							RHTTid=#form.RHTTid#,
							DLsalario=#LvarS#
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
							  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['RHCPid_#i#_#t#']#">
						</cfquery>
					</cfif>
				</cfif>		
		</cfloop>
	</cfif>
</cfif>	
<cfoutput>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Siguiente"
	Default="Siguiente"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Siguiente"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Anterior"
	Default="Anterior"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Anterior"/>
<form name="form1" method="post" action="AdjudicacionPlazas.cfm?Paso=1&RHCconcurso=#form.RHCconcurso#">		
	<cfif isdefined("form.btnSiguiente")>
		<input type="hidden" name="btnSiguiente" value="#BTN_Siguiente#>>">
	</cfif>
	<cfif isdefined("form.btnAnterior")>
		<input type="hidden" name="btnAnterior" value="<<#BTN_Anterior#">
	</cfif>
	<input name="RHCconcurso" type="hidden" value="<cfif isdefined("Form.RHCconcurso") and len(trim(form.RHCconcurso))>#Form.RHCconcurso#</cfif>">
</form>
</cfoutput>
<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
