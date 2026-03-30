<cfif isdefined("form.SDetalle")>
	<cfset LvarDetalle = form.SDetalle>
<cfelse>
	<cfset LvarDetalle = 1> <!---Para No Mostrar los Detalles --->
</cfif>

<cfif not isdefined("form.FCMayor") and isdefined("url.FCMayor")>
	<cfset form.FCMayor = url.FCMayor>
</cfif>

<cfif isdefined("form.FCMayor") and len(form.FCMayor) GT 0>
	<cfset LvarCMayor = form.FCMayor>
</cfif>

<cfif not isdefined("url.Catalogo")>
<cf_templateheader title="Consulta Cuentas de Mayor">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Cuentas de Mayor'>
		<cfif LvarDetalle EQ 1>
	           	<cfquery name="rsReporte" datasource="#session.DSN#">
					select distinct c.Ecodigo, c.Cmayor, c.Ctipo, c.Cbalancen, c.Cdescripcion, c.Crevaluable, 
						<cfif not isdefined("session.Ecodigo") or session.Ecodigo EQ "" or session.Ecodigo EQ 0>
							c.Ecodigo,
						</cfif>
						e.PCEMcodigo,e.PCEMdesc,e.PCEMformato
					from CtasMayor c
						inner join PCEMascaras e 
							inner join PCNivelMascara d
							on e.PCEMid = d.PCEMid
						on e.CEcodigo = c.CEcodigo and e.PCEMid = c.PCEMid
						where 1=1
						<cfif isdefined("session.CEcodigo") and session.CEcodigo NEQ "" and session.CEcodigo NEQ 0>
							 and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
						</cfif>
						<cfif isdefined("session.Ecodigo") and session.Ecodigo NEQ "" and session.Ecodigo NEQ 0>
							and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfif>
						<cfif isdefined("LvarCmayor") and len(LvarCMayor) GT 0>
							and c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCMayor#">
						</cfif>
					order by c.Ecodigo,c.Cmayor, c.Ctipo, c.Cbalancen, e.PCEMcodigo --,d.PCNid
    			</cfquery>
			<cfelseif LvarDetalle EQ 2>
            	<cfquery name="rsReporte" datasource="#session.DSN#">
					select distinct c.Ecodigo, c.Cmayor, 
						case c.Ctipo
							when 'A' then 'Activo'
							when 'P' then 'Pasivo'
							when 'C' then 'Capital'
							when 'I' then 'Ingreso'
							when 'G' then 'Gasto'
							when 'O' then 'Orden'
							else 'Otro' end as Ctipo, 
						case c.Csubtipo
							when 1 then 'Ventas o Ingresos'
							when 2 then 'Costos de Operacion'
							when 3 then 'Gastos de Operacion y Administrativos'
							when 4 then 'Otros Ingresos Gravables'
							when 5 then 'Otros Gastos Deducibles'
							when 6 then 'Ingresos no Gravables'
							when 7 then 'Gastos no Deducibles'
							when 8 then 'Impuestos'
							else '' end as Csubtipo,
						case c.Cbalancen
							when 'D' then 'Debito'
							else 'Credito' end as Cbalancen,
						c.Cdescripcion, 
						case c.Crevaluable
							when 1 then 'SI'
							else 'NO' end as Crevaluable, 
						<cfif not isdefined("session.Ecodigo") or session.Ecodigo EQ "" or session.Ecodigo EQ 0>
							c.Ecodigo,
						</cfif>
						e.PCEMcodigo,e.PCEMdesc,e.PCEMformato
					from CtasMayor c
						inner join PCEMascaras e 
							inner join PCNivelMascara d
							on e.PCEMid = d.PCEMid
						on e.CEcodigo = c.CEcodigo and e.PCEMid = c.PCEMid
					where 1=1
					<cfif isdefined("session.CEcodigo") and session.CEcodigo NEQ "" and session.CEcodigo NEQ 0>
						 and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
					</cfif>
					<cfif isdefined("session.Ecodigo") and session.Ecodigo NEQ "" and session.Ecodigo NEQ 0>
						and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfif>
					<cfif isdefined("LvarCmayor") and len(LvarCMayor) GT 0>
						and c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCMayor#">
					</cfif>
					
		        </cfquery>
			<cfelseif LvarDetalle EQ 3>
				<cfquery name="rsReporte" datasource="#session.DSN#">
					select c.Ecodigo,c.Cmayor, c.Cdescripcion, e.PCEMid,
						e.PCEMcodigo, e.PCEMformato, 
						c1.PCEdescripcion as N1, 
						case when isnull(n2.PCNdep,0) = 0 then c2.PCEdescripcion else '' end as N2, 
						case when isnull(n3.PCNdep,0) = 0 then c3.PCEdescripcion else '' end as N3, 
						case when isnull(n4.PCNdep,0) = 0 then c4.PCEdescripcion else '' end as N4, 
						case when isnull(n5.PCNdep,0) = 0 then c5.PCEdescripcion else '' end as N5, 
						case when isnull(n6.PCNdep,0) = 0 then c6.PCEdescripcion else '' end as N6, 
						case when isnull(n7.PCNdep,0) = 0 then c7.PCEdescripcion else '' end as N7, 
						case when isnull(n8.PCNdep,0) = 0 then c8.PCEdescripcion else '' end as N8, 
						case when isnull(n9.PCNdep,0) = 0 then c9.PCEdescripcion else '' end as N9, 
						case when isnull(n10.PCNdep,0) = 0 then c10.PCEdescripcion else '' end as N10,
						c1.PCEcodigo as C1, 
						case when isnull(n2.PCNdep,0) = 0 then c2.PCEcodigo else 'Depende de nivel ' + convert(varchar, n2.PCNdep) end as C2, 
						case when isnull(n3.PCNdep,0) = 0 then c3.PCEcodigo else 'Depende de nivel ' + convert(varchar, n3.PCNdep) end as C3, 
						case when isnull(n4.PCNdep,0) = 0 then c4.PCEcodigo else 'Depende de nivel ' + convert(varchar, n4.PCNdep) end as C4, 
						case when isnull(n5.PCNdep,0) = 0 then c5.PCEcodigo else 'Depende de nivel ' + convert(varchar, n5.PCNdep) end as C5, 
						case when isnull(n6.PCNdep,0) = 0 then c6.PCEcodigo else 'Depende de nivel ' + convert(varchar, n6.PCNdep) end as C6, 
						case when isnull(n7.PCNdep,0) = 0 then c7.PCEcodigo else 'Depende de nivel ' + convert(varchar, n7.PCNdep) end as C7, 
						case when isnull(n8.PCNdep,0) = 0 then c8.PCEcodigo else 'Depende de nivel ' + convert(varchar, n8.PCNdep) end as C8, 
						case when isnull(n9.PCNdep,0) = 0 then c9.PCEcodigo else 'Depende de nivel ' + convert(varchar, n9.PCNdep) end as C9, 
						case when isnull(n10.PCNdep,0) = 0 then c10.PCEcodigo else 'Depende de nivel ' + convert(varchar, n10.PCNdep) end as C10,
						c1.PCEcatid as I1, c2.PCEcatid as I2, c3.PCEcatid as I3, 
						c4.PCEcatid as I4, c5.PCEcatid as I5, c6.PCEcatid as I6,
						c7.PCEcatid as I7, c8.PCEcatid as I8, c9.PCEcatid as I9, 
						c10.PCEcatid as I10,
						n2.PCNdep as D2, n3.PCNdep as D3, 
						n4.PCNdep as D4, n5.PCNdep as D5, n6.PCNdep as D6,
						n7.PCNdep as D7, n8.PCNdep as D8, n9.PCNdep as D9, 
						n10.PCNdep as D10,
						n1.PCNdescripcion as DS1,
						n2.PCNdescripcion as DS2, n3.PCNdescripcion as DS3, 
						n4.PCNdescripcion as DS4, n5.PCNdescripcion as DS5, n6.PCNdescripcion as DS6,
						n7.PCNdescripcion as DS7, n8.PCNdescripcion as DS8, n9.PCNdescripcion as DS9, 
						n10.PCNdescripcion as DS10
					from CtasMayor c
						inner join PCEMascaras e 
						on e.CEcodigo = c.CEcodigo and e.PCEMid = c.PCEMid
						inner join PCNivelMascara as n1
							inner join PCECatalogo c1
							on n1.PCEcatid = c1.PCEcatid
						on c.PCEMid = n1.PCEMid
						left join PCNivelMascara as n2
							left join PCECatalogo c2
							on n2.PCEcatid = c2.PCEcatid
						on c.PCEMid = n2.PCEMid and n2.PCNid = 2
						left join PCNivelMascara as n3
							left join PCECatalogo c3
							on n3.PCEcatid = c3.PCEcatid
						on c.PCEMid = n3.PCEMid and n3.PCNid = 3
						left join PCNivelMascara as n4
							left join PCECatalogo c4
							on n4.PCEcatid = c4.PCEcatid
						on c.PCEMid = n4.PCEMid and n4.PCNid = 4
						left join PCNivelMascara as n5
							left join PCECatalogo c5
							on n5.PCEcatid = c5.PCEcatid
						on c.PCEMid = n5.PCEMid and n5.PCNid = 5
						left join PCNivelMascara as n6
							left join PCECatalogo c6
							on n6.PCEcatid = c6.PCEcatid
						on c.PCEMid = n6.PCEMid and n6.PCNid = 6
						left join PCNivelMascara as n7
							left join PCECatalogo c7
							on n7.PCEcatid = c7.PCEcatid
						on c.PCEMid = n7.PCEMid and n7.PCNid = 7
						left join PCNivelMascara as n8
							left join PCECatalogo c8
							on n8.PCEcatid = c8.PCEcatid
						on c.PCEMid = n8.PCEMid and n8.PCNid = 8
						left join PCNivelMascara as n9
							left join PCECatalogo c9
							on n9.PCEcatid = c9.PCEcatid
						on c.PCEMid = n9.PCEMid and n9.PCNid = 9
						left join PCNivelMascara as n10
							left join PCECatalogo c10
							on n10.PCEcatid = c10.PCEcatid
						on c.PCEMid = n10.PCEMid and n10.PCNid = 10
					where n1.PCNid = 1
					<cfif isdefined("session.CEcodigo") and session.CEcodigo NEQ "" and session.CEcodigo NEQ 0>
						 and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
					</cfif>
					<cfif isdefined("session.Ecodigo") and session.Ecodigo NEQ "" and session.Ecodigo NEQ 0>
						and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfif>
					<cfif isdefined("LvarCmayor") and len(LvarCMayor) GT 0>
						and c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCMayor#">
					</cfif>
					order by c.Ecodigo, c.Cmayor
				</cfquery>
			</cfif>
		<cfoutput>
			<form id="form1" name="form1" method="post" action="ConsultaCuentas.cfm">
				<table class="AreaFiltro" width="100%">
					<tr>
						<td align="center" colspan="4">
							<strong> FILTROS DE LA CONSULTA </strong>
						</td>
					</tr>
					<tr>
						<td>
									<label>
									<input type="radio" name="SDetalle" id="0" value="1" <cfif LvarDetalle EQ 1> checked </cfif> onclick="submit()" />
									Sin Detalles</label>
						</td>
						<td>
								<label>
								<input type="radio" name="SDetalle" id="1" value="2" <cfif LvarDetalle EQ 2> checked </cfif> onclick="submit()"/>
										Detalles Cuenta</label>  
						</td>
						<td>
							<label>
								<input type="radio" name="SDetalle" id="2" value="3" <cfif LvarDetalle EQ 3> checked </cfif> onclick="submit()"/>
										Definicion Contable</label>  
						</td>
						<td>
							<label>Cuenta de Mayor</label>  
								<input type="input" name="FCmayor" <cfif isdefined("LvarCMayor")>value="#LvarCMayor#"</cfif>/>
										
						</td>
					</tr>
				</table>
			</form>
		</cfoutput>
		<cfif LvarDetalle EQ 1>
			<center>
			<table width="80%" cellpadding="2" cellspacing="10" >
				<tr>
					<cfif not isdefined("session.Ecodigo") or session.Ecodigo EQ "" or session.Ecodigo EQ 0>
						<td align="center" with="7%">E</td>
						<td bgcolor="CCCCCC" bordercolor="000000" align="center" with="8%">Cuenta de Mayor</td>
					<cfelse>
						<td bgcolor="#CCCCCC" bordercolor="#000000" align="center" width="15%"> Cuenta de Mayor </td>
					</cfif>
					<td align="center" width="40%"> Descripcion Cuenta </td>
					<td bgcolor="#CCCCCC" bordercolor="#000000" align="center" width="30%"> Mascara </td>
					<td align="center" width="15%"> Codigo Mascara </td>
				</tr>
			</table>
			</center>
		<cfelseif LvarDetalle EQ 2>
			<center>
			<table width="80%" border="1" cellpadding="2" cellspacing="8">
				<tr>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="25%"> Tipo Cuenta</td>
					<td align="center"  width="25%"> Subtipo </td>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center"  width="25%"> Balance </td>
					<td align="center"  width="25%"> Revaluable </td>
				</tr>
			</table>
			</center> 	
		<cfelseif LvarDetalle EQ 3>
		
		</cfif>
		<hr color="#333333" style="border:groove" /> 
		<cfoutput query="rsReporte" group="Cmayor">
			<cfif LvarDetalle EQ 1>
				<center>
				<table width="80%" border="1" cellpadding="2" cellspacing="10">
					<tr nowrap="nowrap" >
					<cfif not isdefined("session.Ecodigo") or session.Ecodigo EQ "" or session.Ecodigo EQ 0>
						<td align="center" with="7%">#trim(Ecodigo)#</td>
						<td bgcolor="CCCCCC" bordercolor="000000" align="center" with="8%">#trim(Cmayor)#</td>
					<cfelse>
						<td bgcolor="CCCCCC" bordercolor="000000" align="center" with="15%">#trim(Cmayor)#</td>
					</cfif>
						<td align="right" width="40%">#trim(Cdescripcion)#</td>
						<td bgcolor="CCCCCC" bordercolor="000000" align="right" width="30%">#trim(PCEMformato)#</td>
						<td align="center" width="15%">#trim(PCEMcodigo)#</td>
					</tr>
				</table>
				</center>
			<cfelseif LvarDetalle EQ 2>
				<pre> <strong>#Cmayor#</strong>, #Cdescripcion# 
				<cfif not isdefined("session.Ecodigo") or session.Ecodigo EQ "" or session.Ecodigo EQ 0>
					Empresa: #Ecodigo#
				</cfif>  
					Mascara: <strong>#PCEMcodigo# #PCEMformato#</strong> </pre>
				<cfoutput>
					<center>
					<table border="1" cellpadding="2" cellspacing="8" width="80%">
						<tr nowrap="nowrap" >
							<td bgcolor="CCCCCC" bordercolor="000000" align="right" width="25%">#trim(Ctipo)#</td>
							<td align="right" width="25%">#trim(Csubtipo)#</td>
							<td bgcolor="CCCCCC" bordercolor="000000" align="right" width="25%">#trim(Cbalancen)#</td>
							<td align="right" width="25%">#trim(Crevaluable)#</td>
						</tr>
					</table>
					</center>
				</cfoutput>
			<cfelseif LvarDetalle EQ 3>
				<cfquery name="rsMNivel" datasource="#session.DSN#">
					select PCEMid, max(PCNid) as nivel
					from PCNivelMascara 
					where PCEMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#PCEMid#">
					group by PCEMid
				</cfquery>
				<cfset varnivel = rsMNivel.nivel>
				<cfset varPorcentaje = 100/rsMNivel.nivel>
				<cfif varnivel LTE 3>
					<cfset varPorTabla = 60>
				<cfelseif varnivel GT 3 and varnivel LTE 5>
					<cfset varPorTabla = 85>
				<cfelse>
					<cfset varPorTabla = 100>
				</cfif>
				<pre> <strong>#Cmayor#</strong>, #Cdescripcion# 
				<cfif not isdefined("session.Ecodigo") or session.Ecodigo EQ "" or session.Ecodigo EQ 0>
					Empresa: #Ecodigo#
				</cfif>  
				Mascara: <strong>#PCEMcodigo#</strong>, #PCEMformato# </pre>
				<center>
				<table border="1" cellpadding="2" cellspacing="8" width="#varPorTabla#%">
					<tr nowrap="nowrap" >
					<cfloop index="PASO" from="1" to="#varnivel#" step="1">
						<td <cfif not (PASO MOD 2)> bgcolor="CCCCCC" bordercolor="000000" </cfif> align="center">
						<cfswitch expression="#PASO#">
									<cfcase value="1"> #DS1# </cfcase>
									<cfcase value="2"> #DS2# </cfcase>
									<cfcase value="3"> #DS3# </cfcase>
									<cfcase value="4"> #DS4# </cfcase>
									<cfcase value="5"> #DS5# </cfcase>
									<cfcase value="6"> #DS6# </cfcase>
									<cfcase value="7"> #DS7# </cfcase>
									<cfcase value="8"> #DS8# </cfcase>
									<cfcase value="9"> #DS9# </cfcase>
									<cfcase value="10"> #DS10# </cfcase>
									<cfdefaultcase> ERROR </cfdefaultcase>
								</cfswitch>
						</td>
					</cfloop>
					</tr>
					<tr nowrap="nowrap" >
						<cfloop index="PASO" from="1" to="#varnivel#" step="1">
							<td <cfif not (PASO MOD 2)> bgcolor="CCCCCC" bordercolor="000000" </cfif> align="center">
								<a href="ConsultaCuentas.cfm?Catalogo=<cfswitch expression="#PASO#">
									<cfcase value="1">#C1#</cfcase>
									<cfcase value="2">#C2#</cfcase>
									<cfcase value="3">#C3#</cfcase>
									<cfcase value="4">#C4#</cfcase>
									<cfcase value="5">#C5#</cfcase>
									<cfcase value="6">#C6#</cfcase>
									<cfcase value="7">#C7#</cfcase>
									<cfcase value="8">#C8#</cfcase>
									<cfcase value="9">#C9#</cfcase>
									<cfcase value="10">#C10#</cfcase>
									<cfdefaultcase>ERROR</cfdefaultcase>
								</cfswitch>&CatalogoN=<cfswitch expression="#PASO#">
									<cfcase value="1">#N1#</cfcase>
									<cfcase value="2">#N2#</cfcase>
									<cfcase value="3">#N3#</cfcase>
									<cfcase value="4">#N4#</cfcase>
									<cfcase value="5">#N5#</cfcase>
									<cfcase value="6">#N6#</cfcase>
									<cfcase value="7">#N7#</cfcase>
									<cfcase value="8">#N8#</cfcase>
									<cfcase value="9">#N9#</cfcase>
									<cfcase value="10">#N10#</cfcase>
									<cfdefaultcase>ERROR</cfdefaultcase>
								</cfswitch>&Tipo=<cfswitch expression="#PASO#">
									<cfcase value="1"><cfif not left(C1,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="2"><cfif not left(C2,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="3"><cfif not left(C3,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="4"><cfif not left(C4,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="5"><cfif not left(C5,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="6"><cfif not left(C6,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="7"><cfif not left(C7,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="8"><cfif not left(C8,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="9"><cfif not left(C9,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfcase value="10"><cfif not left(C10,7) EQ "Depende">Padre<cfelse>Hijo</cfif></cfcase>
									<cfdefaultcase>ERROR</cfdefaultcase>
								</cfswitch>&Depende=<cfswitch expression="#PASO#">
									<cfcase value="1">nada</cfcase>
									<cfcase value="2">#C1#</cfcase>
									<cfcase value="3">#C2#</cfcase>
									<cfcase value="4">#C3#</cfcase>
									<cfcase value="5">#C4#</cfcase>
									<cfcase value="6">#C5#</cfcase>
									<cfcase value="7">#C6#</cfcase>
									<cfcase value="8">#C7#</cfcase>
									<cfcase value="9">#C8#</cfcase>
									<cfcase value="10">#C9#</cfcase>
									<cfdefaultcase>ERROR</cfdefaultcase>
									</cfswitch>&Mascara=#PCEMid#" target="_blank">
								<cfswitch expression="#PASO#">
									<cfcase value="1"> #C1# </cfcase>
									<cfcase value="2"> #C2# </cfcase>
									<cfcase value="3"> #C3# </cfcase>
									<cfcase value="4"> #C4# </cfcase>
									<cfcase value="5"> #C5# </cfcase>
									<cfcase value="6"> #C6# </cfcase>
									<cfcase value="7"> #C7# </cfcase>
									<cfcase value="8"> #C8# </cfcase>
									<cfcase value="9"> #C9# </cfcase>
									<cfcase value="10"> #C10# </cfcase>
									<cfdefaultcase> ERROR </cfdefaultcase>
								</cfswitch>
								</a>
							</td>
						</cfloop>
					</tr>
					<tr nowrap="nowrap" >
						<cfloop index="PASO" from="1" to="#varnivel#" step="1">
							<td <cfif not (PASO MOD 2)> bgcolor="CCCCCC" bordercolor="000000" </cfif> align="center">
								<cfswitch expression="#PASO#">
									<cfcase value="1"> #N1# </cfcase>
									<cfcase value="2"> #N2# </cfcase>
									<cfcase value="3"> #N3# </cfcase>
									<cfcase value="4"> #N4# </cfcase>
									<cfcase value="5"> #N5# </cfcase>
									<cfcase value="6"> #N6# </cfcase>
									<cfcase value="7"> #N7# </cfcase>
									<cfcase value="8"> #N8# </cfcase>
									<cfcase value="9"> #N9# </cfcase>
									<cfcase value="10"> #N10# </cfcase>
									<cfdefaultcase> ERROR </cfdefaultcase>
								</cfswitch>
							</td>
						</cfloop>
					</tr>
				</table>
				</center>
			</cfif>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfelse>
	<cfif isdefined("url.Tipo") AND url.Tipo EQ "Padre">
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select d.PCDvalor, d.PCDdescripcion, d.PCDactivo
			from PCECatalogo e
				inner join PCDCatalogo d
				on e.PCEcatid = d.PCEcatid
			where e.PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Catalogo#">
			order by d.PCDvalor
    	</cfquery>
	<cfelseif isdefined("url.Tipo") AND url.Tipo EQ "Hijo" AND left(url.Depende,7) NEQ "Depende">
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select e1.PCEcodigo as Padre, e1.PCEdescripcion as DPadre,d1.PCDvalor as PValor,d1.PCDdescripcion as Pdesc,
				e2.PCEcodigo,e2.PCEdescripcion,d2.PCDvalor,d2.PCDdescripcion
			from PCECatalogo e1
				inner join PCDCatalogo d1
					inner join PCECatalogo e2 
						inner join PCDCatalogo d2
						on d2.PCEcatid = e2.PCEcatid
					on d1.PCEcatidref = e2.PCEcatid
				on e1.PCEcatid = d1.PCEcatid
			where e1.PCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Depende#">
			order by d1.PCDvalor
    	</cfquery>
		<cfquery dbtype="query" name="rsPadre">
			select distinct Padre, DPadre
			from rsReporte
		</cfquery>
		<cfif rsPadre.recordcount EQ 1>
			<cfset varPadre = rsPadre.Padre>
			<cfset varDPadre = rsPadre.DPadre>
		<cfelse>
			<cfthrow message="Error Se ha obtenido mas de 1 catalogo padre para el nivel solicitado">
		</cfif>
	</cfif>
	
   	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Cuentas de Mayor'>
	<cfoutput>
		<center>
		<table border="1" cellpadding="2" cellspacing="8" width="80%">
			<tr nowrap="nowrap" >
				<td align="center" colspan="2">
					<cfif isdefined("url.Tipo") AND url.Tipo EQ "Hijo" AND left(url.Depende,7) NEQ "Depende">
							Valores Para el Nivel Hijo depende del catalogo #varPadre#,#varDPadre#
					<cfelseif isdefined("url.Tipo") AND url.Tipo EQ "Hijo" AND left(url.Depende,7) EQ "Depende">
						Valores Para el Nivel Hijo <strong> LOS VALORES PARA EL CATALOGO HIJO NO PUEDEN SER OBTENIDOS, EL CATALOGO PADRE 
												TAMBIEN DEPENDE DE OTRO CATALOGO. CONSULTE LA CUENTA DESDE EL MODULO DE 
												CONTABILIDAD GENERAL, "Consulta de Cuentas Financieras" </strong>
					<cfelse>
						Valores Para el Catalogo <strong>#url.Catalogo#:#url.CatalogoN#</strong>
					</cfif>
				</td>
			</tr>
		<cfif not isdefined("url.Tipo") OR url.Tipo NEQ "Hijo">
			<tr nowrap="nowrap" >
				<td width="20%">
					Valor
				</td>
				<td width="80%">
					Descripcion
				</td>
			</tr>
		</cfif>
		</table>
		</center>
	</cfoutput>
	<cfif isdefined("url.Tipo") AND url.Tipo EQ "Hijo" AND left(url.Depende,7) NEQ "Depende">
		<cfoutput query="rsReporte" group="Pvalor">
			<strong>Valor Padre:#Pvalor#,#Pdesc#</strong> Catalogo Hijo:#PCEcodigo#,#PCEdescripcion#
			<center>
			<table border="1" cellpadding="2" cellspacing="8" width="80%">
				<tr nowrap="nowrap" >
					<td width="20%">
						Valor
					</td>
					<td width="80%">
						Descripcion
					</td>
				</tr>
			<cfoutput>
				<tr nowrap="nowrap" >
					<td width="20%">
						#PCDvalor#
					</td>
					<td width="80%">
						#PCDdescripcion#
					</td>
				</tr>
			</cfoutput>
			</table>
			</center>
		</cfoutput>
	<cfelseif isdefined("url.Tipo") AND url.Tipo EQ "Hijo" AND left(url.Depende,7) EQ "Depende">
		CONSULTA A CUENTA DE MAYOR DEMASIADO COMPLEJA, CONSULTE LA CUENTA DESDE EL MODULO DE CONTABILIDAD GENERAL
	<cfelse>
		<cfoutput query="rsReporte">
			<center>
			<table border="1" cellpadding="2" cellspacing="8" width="80%">
				<tr nowrap="nowrap" >
					<td width="20%">
						#rsReporte.PCDvalor#
					</td>
					<td width="80%">
						#rsReporte.PCDdescripcion#
					</td>
				</tr>
			</table>
			</center>
		</cfoutput>
	</cfif>	
    <cf_web_portlet_end>
</cfif>