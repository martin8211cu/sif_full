<!--- Cuando es un cambio de empresa se realizan las consultas de los catalogos en la nueva empresa --->
<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
	<cfset vn_Ecodigo = rsAccion.EcodigoRef>
	<cfquery name="rsTiposNomina2" datasource="#Session.DSN#">
		select rtrim(Tcodigo) as Tcodigo, Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.EcodigoRef#">
		order by Tdescripcion
	</cfquery>
	
	<cfquery name="rsRegimenVacaciones2" datasource="#Session.DSN#">
		select RVid, Descripcion
		from RegimenVacaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Descripcion
	</cfquery>
	
	<cfquery name="rsOficinas2" datasource="#Session.DSN#">
		select Ocodigo, Odescripcion 
		from Oficinas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Odescripcion
	</cfquery>
	
	<cfquery name="rsDeptos2" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion 
		from Departamentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Ddescripcion
	</cfquery>
	
	<cfquery name="rsJornadas2" datasource="#Session.DSN#">
		select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
		from RHJornadas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.EcodigoRef#">
		order by Descripcion
	</cfquery>

<cfelse>
	<cfset vn_Ecodigo = Session.Ecodigo>
	<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
		select rtrim(Tcodigo) as Tcodigo, Tdescripcion
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Tdescripcion
	</cfquery>
	
	<cfquery name="rsRegimenVacaciones" datasource="#Session.DSN#">
		select RVid, Descripcion
		from RegimenVacaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Descripcion
	</cfquery>
	
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Ocodigo, Odescripcion 
		from Oficinas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Odescripcion
	</cfquery>
	
	<cfquery name="rsDeptos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion 
		from Departamentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Ddescripcion
	</cfquery>
	
	<cfquery name="rsJornadas" datasource="#Session.DSN#">
		select RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion 
		from RHJornadas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by Descripcion
	</cfquery>
	
</cfif>

<!----================ TRADUCCION ===================----->
<cfinvoke key="LB_Lista_de_plazas_presupuestarias" default="Lista de plazas presupuestarias"	 returnvariable="LB_Lista_de_plazas_presupuestarias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Lista_de_puestos" default="Lista de puestos"	 returnvariable="LB_Lista_de_puestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Debe_seleccionar_la_plaza" default="Debe seleccionar la plaza"	 returnvariable="MSG_Debe_seleccionar_la_plaza" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ListaPuestosAlternos" default="Lista de Puestos Alternos"	 returnvariable="LB_ListaPuestosAlternos" component="sif.Componentes.Translate" method="Translate"/>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		<tr>
			<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate></div></td>
	  	</tr>
		<tr>
			<td height="25" class="fileLabel" nowrap><p><cf_translate key="LB_Empresa">Empresa</cf_translate></p></td>
			<td height="25" nowrap>
				<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
					#rsEmpresaReferencia.Enombre#
				<cfelse>			
					#Session.Enombre#
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Plaza">Plaza</cf_translate></td>
			<td height="25" nowrap>
				<input type="hidden" name="RHPid" value="<cfif rsAccion.RHPid NEQ "">#rsAccion.RHPid#<cfelse>#rsEstadoActual.RHPid#</cfif>">
		                <!---<input type="hidden" name="LTporcplazaMax" value="<cfif rsAccion.RHPid NEQ "">#rsAccion.RHAporc#<cfelse>#rsEstadoActual.LTporcplaza#</cfif>">--->
		                <input type="hidden" name="LTporcplazaMax" value="<cfif isdefined('rsPorcentaje')>#rsPorcentaje.Disponible#<cfelse>100</cfif>">

				<input type="hidden" name="RHPPid" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPPid))>#rsAccion.RHPPid#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.RHPPid))>#rsEstadoActual.RHPPid#</cfif>">
				<input type="text" name="RHPPcodigo" id="RHPPcodigo" tabindex="1"
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPPcodigo))>#rsAccion.RHPPcodigo#<cfelseif rsAccion.RHTcomportam NEQ 9 and  isdefined("rsEstadoActual") and len(trim(rsEstadoActual.RHPPcodigo))>#rsEstadoActual.RHPPcodigo#</cfif>" 
					onfocus="this.select()"
					size="10" 
					maxlength="10"
					<cfif rsAccion.RHTcplaza EQ 0 or not Lvar_Modifica>
						readonly=""
						style="border:0"
					</cfif>
					<cfif rsAccion.RHTcplaza EQ 1 and Lvar_Modifica>
						onblur="javascript: FuncTraePlaza(this.value); "
					</cfif>>
				<input type="text" name="RHPPdescripcion" id="RHPPdescripcion" tabindex="-1" disabled
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPPdescripcion))>#rsAccion.RHPPdescripcion#<cfelseif rsAccion.RHTcomportam NEQ 9 and  isdefined("rsEstadoActual") and len(trim(rsEstadoActual.RHPPdescripcion))>#rsEstadoActual.RHPPdescripcion#</cfif>" 
					onfocus="this.select()"
					size="30" 
					<cfif rsAccion.RHTcplaza EQ 0 or not Lvar_Modifica>
					style="border:0"
					</cfif>				
					maxlength="80">
				<cfif rsAccion.RHTcplaza EQ 1 and Lvar_Modifica>
					<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_plazas_presupuestarias#" name="imagen" width="18" height="14" border="0" align="absmiddle" onclick='javascript: doConlisPlaza();'></a>					
				</cfif>	
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Oficina">Oficina</cf_translate></td>
			<td height="25" nowrap>												
				<input type="text" name="Odescripcion" readonly="" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Odescripcion))>#rsAccion.Odescripcion#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.Odescripcion))>#rsEstadoActual.Odescripcion#</cfif>" style="border:0;" size="30">			
				<input size="0" type="hidden" name="Ocodigo" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Ocodigo))>#rsAccion.Ocodigo#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.Ocodigo))>#rsEstadoActual.Ocodigo#</cfif>">
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Departamento">Departamento</cf_translate></td>
			<td height="25" nowrap>						
				<input type="text" name="Ddescripcion"  readonly="" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Ddescripcion))>#rsAccion.Ddescripcion#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.Ddescripcion))>#rsEstadoActual.Ddescripcion#</cfif>" style="border:0;" size="30">			
				<input size="0" type="hidden" name="Dcodigo" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Dcodigo))>#rsAccion.Dcodigo#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.Dcodigo))>#rsEstadoActual.Dcodigo#</cfif>">
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
			<td>
				<input  size="40" type="text" style="border:0" name="CFuncional" readonly="" value="<cfif isdefined("rsAccion") and len(trim(rsAccion.Ctrofuncional))>#rsAccion.Ctrofuncional#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.Ctrofuncional))>#rsEstadoActual.Ctrofuncional#</cfif>">			
			</td>
		</tr>
        
		<cfif usaEstructuraSalarial EQ 1>
			<tr>
				<td colspan="2">
					<cfset emp = Session.Ecodigo>
					<!--- En caso de Cambio de Empresa --->
					<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
						<cfset emp = rsAccion.EcodigoRef>
					</cfif>
					
					<!--- OPARRALES 2019-02-28 Modificacion para Acciones de tipo Cambio --->
					<cfset varBoolText = "true">
					<cfif rsAccion.RHTcomportam eq 6>
						<cfset varBoolText = "false">
					</cfif>

					<cfif Len(Trim(rsAccion.RHCPlinea))>
						<cf_rhcategoriapuesto form="form1" query="#rsAccion#" index="3"
							tablaReadonly="#varBoolText#" categoriaReadonly="#varBoolText#" puestoReadonly="#varBoolText#" incluyeTabla="false" Ecodigo="#emp#">
					<cfelseif Len(Trim(rsEstadoActual.RHCPlinea))>
						<cf_rhcategoriapuesto form="form1" query="#rsEstadoActual#" index="3"
						tablaReadonly="#varBoolText#" categoriaReadonly="#varBoolText#" puestoReadonly="#varBoolText#" incluyeTabla="false" Ecodigo="#emp#">
					<cfelse>
					
						<cfif isdefined ('rsAccion') and len(trim(rsAccion.RHPid)) gt 0>
                            <cfquery name="rsBusqueda" datasource="#session.dsn#">
                                select m.RHTTid,m.RHCid,m.RHMPPid,t.RHTTcodigo, 
                                t.RHTTdescripcion,mp.RHMPPcodigo,mp.RHMPPdescripcion,c.RHCcodigo,c.RHCdescripcion 
                                 from RHPlazas p
                                    inner join RHMovPlaza m
                                        inner join RHMaestroPuestoP mp
                                        on m.RHMPPid=mp.RHMPPid
                                        inner join RHCategoria c
                                        on c.RHCid=m.RHCid
                                    on m.RHPPid=p.RHPPid
                                    inner join RHTTablaSalarial t
                                    on t.RHTTid=m.RHTTid
                                where p.RHPid=#rsAccion.RHPid#
                                and p.Ecodigo=#session.Ecodigo#								
                            </cfquery>
						</cfif>
						<cfif isdefined ('rsBusqueda') and rsBusqueda.recordcount gt 0>
							<cf_rhcategoriapuesto query="#rsBusqueda#" form="form1" tablaReadonly="false" categoriaReadonly="false" puestoReadonly="false" 
								incluyeTabla="false" Ecodigo="#emp#"  index="3">
						<cfelse>
							<cf_rhcategoriapuesto form="form1" tablaReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#"  index="3" 
							categoriaReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#" 
							puestoReadonly="#rsAccion.RHTccatpaso EQ 0 OR not Lvar_Modifica#" incluyeTabla="false" Ecodigo="#emp#">
						</cfif>
					</cfif>
				</td>
			</tr>
           <cfif  rsTipoAccionComp.RHCatParcial GT 0 or (Len(Trim(rsEstadoActual.RHCPlineaP)) and rsEstadoActual.RHCPlineaP GT 0) GT 0 or Len(Trim(rsAccion.RHCPlineaP)) GT 0 and rsAccion.RHCPlineaP GT 0>
				<tr><td align="center" colspan="2" class="titulo" ><strong>Puesto-Categoría Propuesta</strong></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2">
                        <cfquery name="rsAcciones" datasource="#session.dsn#">
                            select RHCatParcial from RHTipoAccion where RHTid=#rsAccion.RHTid#
                        </cfquery>
                        <cfif rsAcciones.RHCatParcial EQ 0>
							<cfset Lvar_CatPropM= true>
                        <cfelse>
                        	<cfset Lvar_CatPropM= false>
						</cfif>
						<cfset emp = Session.Ecodigo>
                        <!--- En caso de Cambio de Empresa --->
                        <cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
                            <cfset emp = rsAccion.EcodigoRef>
                        </cfif>
                        <cfif Len(Trim(rsAccion.RHCPlineaP))>			 
                            <cfquery name="rsCatProp" datasource="#session.DSN#">
                                select RHTTid as RHTTid4, RHMPPid as RHMPPid4, a.RHCid as RHCid4, RHCcodigo as RHCcodigo4
                                from RHCategoriasPuesto a
                                inner join RHCategoria b
                                    on b.RHCid = a.RHCid
                                where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHCPlineaP#">
                            </cfquery>
                            <!--- <cf_dump var="#rsCatProp#"> --->
                            <cf_rhcategoriapuesto form="form1" query="#rsCatProp#" 
                            tablaReadonly="#Lvar_CatPropM#" categoriaReadonly="#Lvar_CatPropM#" puestoReadonly="#Lvar_CatPropM#" incluyeTabla="false" Ecodigo="#emp#"
                            index="4">
                         <cfelseif Len(Trim(rsEstadoActual.RHCPlineaP))>			 
                            <cfquery name="rsCatProp" datasource="#session.DSN#">
                                select RHTTid as RHTTid4, RHMPPid as RHMPPid4, a.RHCid as RHCid4, RHCcodigo as RHCcodigo4
                                from RHCategoriasPuesto a
                                inner join RHCategoria b
                                    on b.RHCid = a.RHCid
                                where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHCPlineaP#">
                            </cfquery>
                            <!--- <cf_dump var="#rsCatProp#"> --->
                            <cf_rhcategoriapuesto form="form1" query="#rsCatProp#" 
                            tablaReadonly="#Lvar_CatPropM#" categoriaReadonly="#Lvar_CatPropM#" puestoReadonly="#Lvar_CatPropM#" incluyeTabla="false" Ecodigo="#emp#"
                            index="4">
                        <cfelse>
                            <cf_rhcategoriapuesto form="form1" tablaReadonly="false" 
                            incluyeTabla="false" Ecodigo="#emp#" index="4">
                        </cfif>
					</td>
				</tr>
          </cfif>

		</cfif>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_PuestoRH">Puesto RH</cf_translate></td>
			<td height="25" nowrap>			
				<input type="hidden" name="RHPcodigo" id="RHPcodigo" tabindex="-1"
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPcodigo))>#rsAccion.RHPcodigo#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.RHPcodigo))>#rsEstadoActual.RHPcodigo#</cfif>" 
					size="0">
				<input type="text" name="RHPcodigoext" id="RHPcodigoext" tabindex="1" 
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPcodigoext))>#rsAccion.RHPcodigoext#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.RHPcodigoext))>#rsEstadoActual.RHPcodigoext#</cfif>" 
					onfocus="this.select()" 			
					size="10" 
					maxlength="10"					
					<cfif rsAccion.RHTcpuesto EQ 0 or not Lvar_Modifica>
					readonly=""
					style="border:0"
					</cfif>
					<cfif rsAccion.RHTcpuesto EQ 1 and Lvar_Modifica>
					onblur="javascript: FuncTraePlaza(document.form1.RHPPcodigo.value); "
					</cfif>
					onblur="javascript:FuncTraePuesto(document.form1.RHPcodigoext.value); ">
				<input type="text" name="RHPdescpuesto" id="RHPdescpuesto" tabindex="-1" disabled
					value="<cfif isdefined("rsAccion") and len(trim(rsAccion.RHPdescpuesto))>#rsAccion.RHPdescpuesto#<cfelseif rsAccion.RHTcomportam NEQ 9 and isdefined("rsEstadoActual") and len(trim(rsEstadoActual.RHPdescpuesto))>#rsEstadoActual.RHPdescpuesto#</cfif>" 
					onfocus="this.select()"
					<cfif rsAccion.RHTcpuesto EQ 0 or not Lvar_Modifica>
					style="border:0"
					</cfif>
					size="30" 
					maxlength="80">
				<cfif rsAccion.RHTcpuesto EQ 1 and Lvar_Modifica>
					<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_puestos#" name="imagen" width="18" height="14" border="0" align="absmiddle" onclick='javascript: doConlisPuesto();'></a>					
				</cfif>
			</td>
		</tr>	 
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Jornada">Jornada</cf_translate></td>
			<td height="25" nowrap>
				<cfif rsAccion.RHTcjornada EQ 1 and Lvar_Modifica>
					<!--- Cambio de Empresa --->
					<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
						<select name="RHJid" id="RHJid">
							<cfloop query="rsJornadas2"> 
								<option value="#rsJornadas2.RHJid#" <cfif rsAccion.RHJid NEQ ""><cfif rsJornadas2.RHJid EQ rsAccion.RHJid>selected</cfif><cfelse><cfif rsJornadas2.RHJid EQ rsEstadoActual.RHJid>selected</cfif></cfif>>#rsJornadas2.Descripcion#</option>
							</cfloop> 
						</select>
					<cfelse>
						<select name="RHJid" id="RHJid">
							<cfloop query="rsJornadas"> 
								<option value="#rsJornadas.RHJid#" <cfif rsAccion.RHJid NEQ ""><cfif rsJornadas.RHJid EQ rsAccion.RHJid>selected</cfif><cfelse><cfif rsJornadas.RHJid EQ rsEstadoActual.RHJid>selected</cfif></cfif>>#rsJornadas.Descripcion#</option>
							</cfloop> 
						</select>
					</cfif>
				<cfelse>
					<input type="hidden" name="RHJid" value="<cfif rsAccion.RHJid NEQ "">#rsAccion.RHJid#<cfelse>#rsEstadoActual.RHJid#</cfif>"><cfif rsAccion.RHJid NEQ "">#rsAccion.Jornada#<cfelse>#rsEstadoActual.Jornada#</cfif>
				</cfif>
			</td>
		</tr>

		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Porcetaje_de_Plaza">Porcentaje de Plaza</cf_translate></td>
			<td height="25" nowrap>
				<cfif RHTporcPlazaCHK eq 1>
					<input 
						name="LTporcplaza" 
						type="text" 
						size="8" 
						maxlength="6"  
						onfocus="this.value=qf(this); this.select();" 
						onblur="javascript: fm(this,2);"  
						onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						style="text-align: right;" 
						value="<cfif rsAccion.RHAporc NEQ ""  and rsAccion.RHAporc NEQ 0>#LSCurrencyFormat(rsAccion.RHAporc,'none')#<cfelse>#LSCurrencyFormat(rsTipoAccionComp.RHTporc,'none')#</cfif>"> %
						<!---value="<cfif rsAccion.RHAporc NEQ "" and rsAccion.RHAporc NEQ 0>#rsAccion.RHAporc#<cfelse>#rsEstadoActual.LTporcplaza#</cfif>"> %--->
				<cfelse>
					<input 
						name="LTporcplaza" 
						type="hidden" 
						value="<cfif rsAccion.RHAporc NEQ "" and rsAccion.RHAporc NEQ 0>#rsAccion.RHAporc#<cfelse>#rsEstadoActual.LTporcplaza#</cfif>">
						<cfif rsAccion.RHAporc NEQ "" and rsAccion.RHAporc NEQ 0 >
							#LSCurrencyFormat(rsAccion.RHAporc,'none')#
						<cfelse>
							#LSCurrencyFormat(rsEstadoActual.LTporcplaza,'none')#
						</cfif> %				
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Porcentaje_de_Salario_Fijo">Porcentaje de Salario Fijo</cf_translate></td>
			<td height="25" nowrap>
				<cfif RHTcsalariofijo eq 1>
					<input 
						name="LTporcsal" 
						type="text" 
						size="8" 
						maxlength="6"  
						onfocus="this.value=qf(this); this.select();" 
						onblur="javascript: fm(this,2);"  
						onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						style="text-align: right;" 
						value="<cfif len(trim(rsAccion.RHAporcsal)) and  rsAccion.RHAporcsal NEQ -1 >#LSCurrencyFormat(rsAccion.RHAporcsal,'none')#<cfelse>#LSCurrencyFormat(RHTporcsal,'none')#</cfif>"> %
				<cfelse>
                	
					<input 
						name="LTporcsal" 
						type="hidden" 
						value="<cfif rsAccion.RHAporcsal GT 0>#rsAccion.RHAporcsal# <cfelseif isdefined('rsEstadoActual') and  rsEstadoActual.RecordCount  GT 0 > #rsEstadoActual.LTporcplaza*RHTporcsal/100#  <cfelse> #LSCurrencyFormat(RHTporcsal,'none')#</cfif>">
						<cfif rsAccion.RHAporcsal GT 0>
							#LSCurrencyFormat(rsAccion.RHAporcsal,'none')#
						 <cfelseif isdefined('rsEstadoActual') and  rsEstadoActual.RecordCount  GT 0 >
							#LSCurrencyFormat(rsEstadoActual.LTporcplaza*RHTporcsal/100,'none')#
                         <cfelse>   
                         	#LSCurrencyFormat(RHTporcsal,'none')#
						</cfif> %				
				</cfif>

			</td>
		</tr>
		<tr>
			<td class="fileLabel" width="47%" height="25" nowrap><cf_translate key="LB_Tipo_de_Nomina">Tipo de N&oacute;mina</cf_translate></td>
			<td height="25" nowrap>
				<cfset Lvar_Tcodigo = "">
				<cfif rsAccion.RHTctiponomina EQ 1 and Lvar_Modifica>
					<!--- Cambio de Empresa --->
					<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
						<cfquery name="rsTcodigo" datasource="#session.DSN#">
							select Tcodigo, Tdescripcion
							from TiposNomina
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAccion.EcodigoRef#">
						</cfquery>
						<input type="hidden" name="Tcodigoant" value="#rsEstadoActual.Tcodigo#">
						
						<cf_rhtiponominaCombo index="0" query="#rsTcodigo#" todas="False" Ecodigo = "#rsAccion.EcodigoRef#">
						
					<cfelse>
						<cfif Len(Trim(rsAccion.Tcodigo))>
							<cfset Lvar_Tcodigo = rsAccion.Tcodigo>
						<cfelse>
							<cfset Lvar_Tcodigo = rsEstadoActual.Tcodigo>
						</cfif>
						<cf_rhtiponominaCombo index="0" query="#rsAccion#" todas="False">
					</cfif>
				<cfelse>
					<cfset Lvar_Tcodigo = rsAccion.Tcodigo>
					<cfif Len(Trim(rsAccion.Tcodigo))>
						<cfset Lvar_Tcodigo = rsAccion.Tcodigo>
					<cfelse>
						<cfset Lvar_Tcodigo = rsEstadoActual.Tcodigo>
					</cfif>
					<input type="hidden" name="Tcodigo" value="<cfif Len(Trim(rsAccion.Tcodigo))>#rsAccion.Tcodigo#<cfelse>#rsEstadoActual.Tcodigo#</cfif>">
					<cfif Len(Trim(rsAccion.Tcodigo))>#rsAccion.Tdescripcion#<cfelse>#rsEstadoActual.Tdescripcion#</cfif>
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="fileLabel" height="25" nowrap><cf_translate key="LB_Registro_de_Vacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
			<td height="25" nowrap>
				<cfif rsAccion.RHTcregimenv EQ 1 and Lvar_Modifica>
					<!--- Cambio de Empresa --->
					<cfif rsAccion.RHTcomportam EQ 9 and rsAccion.RHTcempresa EQ 1>
						<select name="RVid">
							<cfloop query="rsRegimenVacaciones2">
								<option value="#rsRegimenVacaciones2.RVid#" <cfif rsAccion.RVid NEQ ""><cfif rsRegimenVacaciones2.RVid EQ rsAccion.RVid>selected</cfif><cfelse><cfif rsRegimenVacaciones2.RVid EQ rsEstadoActual.RVid>selected</cfif></cfif>>#rsRegimenVacaciones2.Descripcion#</option>
							</cfloop>
						</select>
					<cfelse>
						<select name="RVid">
							<cfloop query="rsRegimenVacaciones">
								<option value="#rsRegimenVacaciones.RVid#" <cfif rsAccion.RVid NEQ ""><cfif rsRegimenVacaciones.RVid EQ rsAccion.RVid>selected</cfif><cfelse><cfif rsRegimenVacaciones.RVid EQ rsEstadoActual.RVid>selected</cfif></cfif>>#rsRegimenVacaciones.Descripcion#</option>
							</cfloop>
						</select>
					</cfif>
				<cfelse>
					<input type="hidden" name="RVid" value="<cfif rsAccion.RVid NEQ "">#rsAccion.RVid#<cfelse>#rsEstadoActual.RVid#</cfif>"><cfif rsAccion.RVid NEQ "">#rsAccion.RegVacaciones#<cfelse>#rsEstadoActual.RegVacaciones#</cfif>
				</cfif>
			</td>
		</tr>	
		<cfif usaEstructuraSalarial EQ 1 and (isdefined('rsPuestoAlterno') or rsAccion.RHTcomportam EQ 1 or rsAccion.RHTcomportam EQ 6 or rsAccion.RHTcomportam EQ 12)>	
			<tr bgcolor="CCCCCC" height="25"><td colspan="2" align="center"><strong><cf_translate key="LB_PuestoAlterno">Puesto Alterno</cf_translate></strong></td></tr>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Puesto_RH">Puesto RH</cf_translate></td>
				<td height="25" nowrap>
					<cfset ArrayPuesto=''>
                	<cfif isdefined('rsPuestoAlterno') and rsPuestoAlterno.RHPcodigo GT 0>
                        <cfquery name="rsPuesto" datasource="#session.DSN#">
                            select RHPcodigo,RHPdescpuesto
                            from RHPuestos 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                              and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPuestoAlterno.RHPcodigo#">
                        </cfquery>
                        <cfset ArrayPuesto='#rsPuesto.RHPcodigo#,#rsPuesto.RHPdescpuesto#'>
                    </cfif>
                   
                    <cfset filtro = ''>
                    <cf_conlis 
                        title="#LB_ListaPuestosalternos#"
                        campos = "RHPcodigoAlt, RHPdescripcionAlt" 
                        desplegables = "S,S" 
                        modificables = "S,N"
                        size = "10,30"
                        values="#ArrayPuesto#" 
                        tabla="RHPuestos"
                        columnas="RHPcodigo as RHPcodigoAlt, RHPdescpuesto  as RHPdescripcionAlt"
                        filtro="Ecodigo = #session.Ecodigo# #filtro#"
                        desplegar="RHPcodigoAlt, RHPdescripcionAlt"
                        filtrar_por="RHPcodigo, RHPdescpuesto"
                        etiquetas="#LB_Codigo#, #LB_Descripcion#"
                        formatos="S,S"
                        align="left,left"
                        asignar="RHPcodigoAlt, RHPdescripcionAlt"
                        asignarformatos="S,S"
                        height= "400"
                        width="500"
                        tabindex="1"
                        readonly="#not(rsAccion.RHTCplaza EQ 1)#"
                        showEmptyListMsg="true"
                        EmptyListMsg="#MSG_NoSeEncontraronRegistros#" 
                        funcion="FuncTraePuestoAlt"
                        fparams="RHPcodigoAlt"
                        >
                </td>
			</tr>
            <cfif isdefined('rsPuestoAlterno')>
                <cf_rhcategoriapuesto form="form1" query="#rsPuestoAlterno#" tablaReadonly="true" 
                categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false"
                index="5">
            <cfelse>
			<cf_rhcategoriapuesto form="form1" tablaReadonly="true" 
			categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false"
			index="5">
            
            </cfif>
		</cfif>	  		
	  	<cfif rsAccion.RHTcomportam EQ 3>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Vacaciones_disfrutadas">Vacaciones disfrutadas</cf_translate></td>
				<td height="25" nowrap>
					<!--- Se asume que cuando el tipo de accion es Vacacion no se modifica la jornada --->
					<input type="hidden" name="vacadias" value="#get_vacaciones_disf(rsAccion.RHAlinea, rsEstadoActual.RHJid)#">
					<cfif rsAccion.RHTcvacaciones EQ 1 and Lvar_Modifica>
						<!--- Se hizo esta asignación por separado porque el valor en la caja de texto salía con tabs a la izquierda que no permitían ver el valor a menos que se ejecutara el onblur. --->
						<cfif rsAccion.RHAvdisf NEQ "">
							<cfset valueRHAvdisf = LSCurrencyFormat(rsAccion.RHAvdisf,'none')>
						<cfelse>
							<cfset valueRHAvdisf = LSCurrencyFormat(get_vacaciones_disf(rsAccion.RHAlinea, rsEstadoActual.RHJid), 'none')>
						</cfif>
						<input name="RHAvdisf" type="text" size="8" maxlength="7" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#valueRHAvdisf#">
					<cfelse>
						<input name="RHAvdisf" type="hidden" value="<cfif rsAccion.RHAvdisf NEQ "">#LSCurrencyFormat(rsAccion.RHAvdisf,'none')#<cfelse>#LSCurrencyFormat(get_vacaciones_disf(rsAccion.RHAlinea, rsEstadoActual.RHJid), 'none')#</cfif>">
						<cfif rsAccion.RHAvdisf NEQ "">#LSCurrencyFormat(rsAccion.RHAvdisf,'none')#<cfelse>#LSCurrencyFormat(get_vacaciones_disf(rsAccion.RHAlinea, rsEstadoActual.RHJid), 'none')#</cfif>
					</cfif>
				</td>
			</tr>
			<tr>
				<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Vacaciones_compensadas">Vacaciones compensadas</cf_translate></td>
				<td height="25" nowrap>
					<cfif rsAccion.RHTcvacaciones EQ 1 and Lvar_Modifica>
						<input name="RHAvcomp" type="text" size="8" maxlength="7" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsAccion.RHAvcomp NEQ "">#LSCurrencyFormat(rsAccion.RHAvcomp,'none')#<cfelse>0.00</cfif>">
					<cfelse>
						<input name="RHAvcomp" type="hidden" value="<cfif rsAccion.RHAvcomp NEQ "">#LSCurrencyFormat(rsAccion.RHAvcomp,'none')#<cfelse>0.00</cfif>">
						<cfif rsAccion.RHAvcomp NEQ "">#LSCurrencyFormat(rsAccion.RHAvcomp,'none')#<cfelse>0.00</cfif>
					</cfif>
				</td>
			</tr>
	  	</cfif>
		<!--- Desarrollo DHC - Baroda --->
		<!--- Si la accion es de incapacidad y la empresa proceso dias de enfermedad (p. 960 = 1), se pinta esa seccion de codigo 
			  al cual debe capturar el numero de dias de enfermedad a rebajar al empleado	
		--->
		<cfif rsAccion.RHTcomportam EQ 5>
			<cfquery name="rs_p960" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Pcodigo = 960
			</cfquery>

			<cfif trim(rs_p960.Pvalor) eq 1>
				<cfquery name="rs_saldodiasenf" datasource="#session.DSN#">
					select DEid, sum(DVEenfermedad) as dias
					from DVacacionesEmpleado
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DEid#">
					group by DEid				
				</cfquery>
				<cfset valueRHAdiasenfermedad = 0.00 >
				<!---<cfset valueRHAdiasenfermedad = abs(datediff('d', rsAccion.DLfvigencia, rsAccion.DLffin)) +1 >--->
				<cfif isdefined("rsAccion.RHAdiasenfermedad") and len(trim(rsAccion.RHAdiasenfermedad))>
					<cfset valueRHAdiasenfermedad = LSNumberFormat(rsAccion.RHAdiasenfermedad, '.00') >
				</cfif>
				
				<tr>
					<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Dias_de_Enfermedad">D&iacute;as de Enfermedad</cf_translate></td>
					<td height="25" nowrap><input name="RHAdiasenfermedad" type="text" size="8" maxlength="7" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LSNumberFormat(valueRHAdiasenfermedad, '.00')#"></td>
				</tr>	
			</cfif>
		</cfif>	  
		
	</table>
</cfoutput>
<!---============== Deshabilitar: tabla, puesto y categoria si el salario de la plaza presupuestaria es negociado ==============----->
<cfif (usaEstructuraSalarial EQ 1) and (len(trim(rsAccion.RHMPnegociado)) and rsAccion.RHMPnegociado EQ 'N')>
	<cfif len(trim(rsAccion.RHTTid)) and len(trim(rsAccion.RHMPPid)) and len(trim(rsAccion.RHCid)) and rsAccion.RHTccatpaso EQ 1 AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
		<script type="text/javascript" language="javascript1.2">
			var conlispuesto = document.getElementById("imgRHMPPcodigo");			
			var conliscategoria = document.getElementById("imgRHCcodigo");
			conlispuesto.style.display = 'none';		
			conliscategoria.style.display = 'none';	
			document.form1.RHTTid.disabled = true;
			document.form1.RHMPPcodigo.disabled = true;
			document.form1.RHCcodigo.disabled = true;
		</script>
	</cfif>
</cfif>

<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
<script type="text/javascript" language="javascript1.2">
	var popUpWin5=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin5)
		{
			if(!popUpWin5.closed) popUpWin5.close();
		}
		popUpWin5 = open(URLStr, 'popUpWin5', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	function doConlisPlaza() {
		<cfoutput>
			var params = '?form=form1&empresa=#vn_Ecodigo#&index=3';
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DEid))>	
				params = params + '&DEid=#rsAccion.DEid#';
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLfvigencia))>			
				params = params + '&fechaAcc=#LSDateFormat(rsAccion.DLfvigencia,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLffin))>			
				params = params + '&fechafinAcc=#LSDateFormat(rsAccion.DLffin,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.RHTnoveriplaza))>	
				params = params + '&vfyplz=#rsAccion.RHTnoveriplaza#';
			</cfif>
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1>
				params = params + '&usaEstructuraSalarial=1';
			</cfif>
			<cfif isdefined("rsAccion.RHTccatpaso") and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&PuedeModificar=1";
			</cfif>
		</cfoutput>
		popUpWindow("/cfmx/rh/nomina/operacion/ConlisPlaza_acciones.cfm"+params,10,30,990,600);
	}	
	function FuncTraePlaza(vs_codigo){
		<cfoutput>
			var params = '&form=form1&empresa=#vn_Ecodigo#&index=3';
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DEid))>	
				params = params + '&DEid=#rsAccion.DEid#';
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLfvigencia))>			
				params = params + '&fechaAcc=#LSDateFormat(rsAccion.DLfvigencia,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLffin))>			
				params = params + '&fechafinAcc=#LSDateFormat(rsAccion.DLffin,"dd/mm/yyyy")#';			
			</cfif>
			<cfif isdefined("rsAccion") and len(trim(rsAccion.RHTnoveriplaza))>	
				params = params + '&vfyplz=#rsAccion.RHTnoveriplaza#';
			</cfif>
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1>
				params = params + '&usaEstructuraSalarial=1';
			</cfif>
			<cfif isdefined("rsAccion.RHTccatpaso") and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&PuedeModificar=1";
			</cfif>
		</cfoutput>
		if (vs_codigo!="") {
			var fr = document.getElementById("fr");
			fr.src = "/cfmx/rh/nomina/operacion/rhtraeplaza_accion.cfm?codigo="+vs_codigo+params;
		} else {
			document.form1.RHPPid.value = '';
			document.form1.RHPPcodigo.value = '';
			document.form1.RHPPdescripcion.value = '';
			document.form1.RHTTid3.value='';
			document.form1.RHMPPid3.value='';
			document.form1.RHCid3.value='';
			if (document.form1.RHPPid.value == ''){
				document.form1.RHPcodigo.value = '';
				document.form1.RHPcodigoext.value = '';
				document.form1.RHPdescpuesto.value = '';
				document.form1.RHTTid3.value='';
				document.form1.RHMPPid3.value='';
				document.form1.RHCid3.value='';
			}
		}
	}
	function FuncTraePuestoAlt(vs_codigo){
		<cfoutput>
			var params = '&form=form1&empresa=#vn_Ecodigo#&index=5';
			<cfif isdefined("rsAccion") and len(trim(rsAccion.DLfvigencia))>			
				params = params + '&fechaAcc=#LSDateFormat(rsAccion.DLfvigencia,"dd/mm/yyyy")#';			
			</cfif>
		</cfoutput>
		if (vs_codigo!="") {
			var fr = document.getElementById("fr");
			fr.src = "/cfmx/rh/nomina/operacion/rhtraepuestoAlt_accion.cfm?codigo="+vs_codigo+params;
		} else {
			document.form1.RHTTid5.value='';
			document.form1.RHMPPid5.value='';
			document.form1.RHCid5.value='';
		}
	}


	function doConlisPuesto() {		
		if (document.form1.RHPPid.value == ''){
			<cfoutput>alert("#MSG_Debe_seleccionar_la_plaza#")</cfoutput>;
		}
		else{
			<cfoutput>
				var params = '?form=form1&empresa=#vn_Ecodigo#';
			</cfoutput>		
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1 and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&RHMPPid="+document.form1.RHMPPid.value;
			<cfelseif usaEstructuraSalarial>
				params = params + "&RHMPPid="+document.form1.RHMPPid.value;
			</cfif>
			
			popUpWindow("/cfmx/rh/nomina/operacion/ConlisPuestos_acciones.cfm"+params+"&index="+1,200,150,600,400);
		}
	}
	function FuncTraePuesto(vs_codigo){
		if (document.form1.RHPPid.value == ''){
			<cfoutput>alert("#MSG_Debe_seleccionar_la_plaza#")</cfoutput>;
				document.form1.RHPcodigo.value = '';
				document.form1.RHPcodigoext.value = '';
				document.form1.RHPdescpuesto.value = '';
		}
		else{			
			
			<cfoutput>
				var params = '&form=form1&empresa=#vn_Ecodigo#';	
			</cfoutput>
			<cfif isdefined("usaEstructuraSalarial") and usaEstructuraSalarial EQ 1 and rsAccion.RHTccatpaso EQ 1  AND (len(trim(rsAccion.IDInterfaz)) EQ 0)>
				params = params + "&RHMPPid="+document.form1.RHMPPid.value;
			</cfif>
			if (vs_codigo!="") {
				var fr = document.getElementById("fr");
				fr.src = "/cfmx/rh/nomina/operacion/rhtraepuesto_accion.cfm?codigo="+vs_codigo+params;
			} else {
				document.form1.RHPcodigo.value = '';
				document.form1.RHPcodigoext.value = '';
				document.form1.RHPdescpuesto.value = '';
			}
		}	
	}
</script>