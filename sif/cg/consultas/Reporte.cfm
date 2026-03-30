<cfinvoke key="LB_Asiento" 			default="Asiento" 	returnvariable="LB_Asiento" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Cuentas" 			default="Cuentas" 	returnvariable="LB_Cuentas" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Cuenta" 			default="Cuenta" 	returnvariable="LB_Cuenta" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Descripcion" 			default="Descripci&oacute;n" 	returnvariable="LB_Descripcion" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Inicial" 			default="Inicial" 	returnvariable="LB_Inicial" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Debitos" 			default="Debitos" 	returnvariable="LB_Debitos" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Creditos" 			default="Creditos" 	returnvariable="LB_Creditos" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Oficina" 			default="Oficina" 	returnvariable="LB_Oficina" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Oficinas" 			default="Oficinas" 	returnvariable="LB_Oficinas" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Empresas" 			default="Empresas" 	returnvariable="LB_Empresas" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Parametros" 			default="Par&aacute;metros" 	returnvariable="LB_Parametros" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>  
<cfinvoke key="LB_De" default="De" 	returnvariable="LB_De" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_a" default="a" 	returnvariable="LB_a" 		component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Resumido" default="Reporte Resumido" 	returnvariable="LB_Resumido" 		component="sif.Componentes.Translate" 
method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_DetalladoMes" default="Reporte Detallado por Mes" 	returnvariable="LB_DetalladoMes" 		
component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_DetalladoAsiento" default="Reporte Detallado por Asiento" 	returnvariable="LB_DetalladoAsiento" 		
component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_DetalladoConsecutivo" default="Reporte Detallado por Consecutivo" 	returnvariable="LB_DetalladoConsecutivo" 		
component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Periodo" default="Peri&oacute;do" 	returnvariable="LB_Periodo" 		
component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>
<cfinvoke key="LB_Mes" default="Mes" 	returnvariable="LB_Mes" 		
component="sif.Componentes.Translate" method="Translate" xmlfile="Reporte.xml"/>

<cffunction name="fnPintaReporte" access="private" output="no" hint="Pinta el reporte hacia los archivos planos">
	<cfset contenidohtml = "">
	<!---**************************** --->
	<!--- Estilos para formato de     --->
	<!--- Celdas ,Excel y cortes      --->
	<!---**************************** --->
	<cfsavecontent variable="micontenido">
		<style>
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		<!--table
		{mso-displayed-decimal-separator:"\.";
		mso-displayed-thousand-separator:"\,";}
		@page
		{margin:1.0in .75in 1.0in .75in;
		mso-header-margin:.5in;
		mso-footer-margin:.5in;}
		tr
		{mso-height-source:auto;}
		col
		{mso-width-source:auto;}
		br
		{mso-data-placement:same-cell;}
		.style0
		{mso-number-format:General;
		text-align:general;
		vertical-align:bottom;
		white-space:nowrap;
		mso-rotate:0;
		mso-background-source:auto;
		mso-pattern:auto;
		color:windowtext;
		font-size:10.0pt;
		font-weight:400;
		font-style:normal;
		text-decoration:none;
		font-family:Arial;
		mso-generic-font-family:auto;
		mso-font-charset:0;
		border:none;
		mso-protection:locked visible;
		mso-style-name:Normal;
		mso-style-id:0;}
		td
		{mso-style-parent:style0;
		padding-top:1px;
		padding-right:1px;
		padding-left:1px;
		mso-ignore:padding;
		color:windowtext;
		font-size:10.0pt;
		font-weight:400;
		font-style:normal;
		text-decoration:none;
		font-family:Arial;
		mso-generic-font-family:auto;
		mso-font-charset:0;
		mso-number-format:General;
		text-align:general;
		vertical-align:bottom;
		border:none;
		mso-background-source:auto;
		mso-pattern:auto;
		mso-protection:locked visible;
		white-space:nowrap;
		mso-rotate:0;}
		.xl24
		{mso-style-parent:style0;
		mso-number-format:Standard;}
		.xl25
		{mso-style-parent:style0;
		font-size:9.0pt;
		font-weight:700;
		background:silver;
		mso-pattern:auto none;
		white-space:normal;}
		.xl26
		{mso-style-parent:style0;
		font-weight:700;
		font-family:Arial, sans-serif;
		mso-font-charset:0;}
		.xl27
		{mso-style-parent:style0;
		font-size:8.0pt;
		font-weight:bold;
		font-family:Arial, sans-serif;
		mso-font-charset:0;}
		.xl28
		{mso-style-parent:style0;
		font-size:8.0pt;
		font-family:Arial, sans-serif;
		mso-font-charset:0;}
		.xl29
		{mso-style-parent:style0;
		font-size:8.0pt;
		font-family:Arial, sans-serif;
		mso-number-format:"\@";}
		.xl30
		{mso-style-parent:style0;
		font-size:8.0pt;
		font-weight:bold;
		font-family:Arial, sans-serif;
		mso-number-format:"\@";}
		.x_l28
		{mso-style-parent:style0;
		font-size:8.0pt;
		font-family:Arial, sans-serif;
		mso-font-charset:0;
		mso-number-format:Standard;}	
		.x_l27
		{mso-style-parent:style0;
		font-size:8.0pt;
		font-weight:bold;
		font-family:Arial, sans-serif;
		mso-font-charset:0;
		mso-number-format:Standard;}	
		-->
		</style>
		<!---**************************** --->
		<!--- PINTADO DEL REPORTE         --->
		<!---**************************** --->
		<table width="100%" cellpadding="0" cellspacing="0" border="0" >
		<tr>
		<td>
		<table width="100%" cellpadding="0" cellspacing="0" border="0" >
		<tr><td  colspan="6" class="xl25" align="center" ><cfoutput>#LvarNombreEmpresa#</cfoutput></td></tr>
		<tr><td  colspan="6" class="xl25" align="center" ><cfoutput>#TituloReporte#</cfoutput></td></tr>
		<tr><td  colspan="6" class="xl25" align="center" ><cfoutput>#LB_De# #MesInicial# #form.PERIODOS# #LB_a# #MesFinal# #form.PERIODOS#</cfoutput></td></tr>
		</table>
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, false)>
	<cfsavecontent variable="micontenido">
		<table width="100%" cellpadding="0" cellspacing="0" border="0" >
			<tr>
				<td align="center" colspan="6"  class="xl26">
					<cfif TipoFormato EQ 1>
						<cfoutput>#LB_DetalladoConsecutivo#</cfoutput>
					<cfelseif TipoFormato EQ 2>
						<cfoutput>#LB_DetalladoMes#</cfoutput>
					<cfelseif TipoFormato EQ 3>
						<cfoutput>#LB_DetalladoAsiento#</cfoutput> 
					<cfelse>
						<cfoutput>#LB_Resumido#</cfoutput>
					</cfif>
					<br>
					<cfoutput>#TituloCalcDesc#</cfoutput>
				</td>
			</tr>
			<tr><cfoutput>
				<td nowrap class="xl25">#LB_Cuenta#</td>
				<td nowrap class="xl25">#LB_Descripcion#</td>
				<td nowrap class="xl25" align="right" >#LB_Inicial#</td>
				<td nowrap class="xl25" align="right" >#LB_Debitos#</td>
				<td nowrap class="xl25" align="right" >#LB_Creditos#</td>
				<td nowrap class="xl25" align="right" >Final</td>
                </cfoutput>
			</tr>	
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, false)>	
	<cfloop query="rsCuentasContables">
		<!--- Evalua la condicion --->
		<cfif rsCuentasContables.nivel LE form.NIVELTOT>
			<cfsavecontent variable="micontenido">
			<cfoutput>
				<tr>
					<td class="xl30" nowrap>#rsCuentasContables.Cformato#</td>
					<td class="xl27" nowrap>#rsCuentasContables.Cdescripcion#</td>
					<td class="x_l27" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.saldoini,'none')#</td>
					<td class="x_l27" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.debitos,'none')#</td>
					<td class="x_l27" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.creditos,'none')#</td>
					<td class="x_l27" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.saldofin,'none')#</td>
				</tr>
			</cfoutput>				
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="micontenido">				
			<cfoutput>
				<tr>
					<td class="xl29" nowrap>#rsCuentasContables.Cformato#</td>
					<td class="xl28" nowrap>#rsCuentasContables.Cdescripcion#</td>
					<td class="x_l28" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.saldoini,'none')#</td>
					<td class="x_l28" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.debitos,'none')#</td>
					<td class="x_l28" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.creditos,'none')#</td>
					<td class="x_l28" nowrap align="right">#LSCurrencyFormat(rsCuentasContables.saldofin,'none')#</td>
				</tr>
			</cfoutput>				
			</cfsavecontent>
		</cfif>			
		<cfset fnGraba(micontenido, true, false)>
		<!--- Formatos:
			1. Detallado por Periodo, Mes, Lote ( Asiento Fijo ) y Consecutivo
			2. Resumido por Periodo y Mes
			3. Resumido por  Periodo, Mes y Lote ( Asiento Fijo )
			4. Resumido ( no presenta detalle )
		--->
		<cfif rsCuentasContables.nivel EQ form.NIVELDET and TipoFormato NEQ 4>
			<cfset LvarCcuentaniv = rsCuentasContables.Ccuenta>
			<cfset LvarNivelCtaD  = form.NIVELDET>
			<cfset LvarTiempoActual = gettickcount()>
			<cfquery datasource="#session.dsn#">
				delete from #cubo2#
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into #cubo2# (Ccuenta, Ccuentaniv, Speriodo, Smes1, Smes2)
				select Ccuenta, Ccuentaniv, Speriodo, Smes1, Smes2
				from #cubo# cu
				where cu.Ccuentaniv = #LvarCcuentaniv#
			</cfquery>
			<cfif TipoFormato eq "2" and len(trim(ListaAsientos)) EQ 0>
				<cfquery name="rsDetalle" datasource="#session.dsn#">
					select #LvarPeriodo# as Speriodo, s.Smes <cfif isdefined("form.ID_incsucursal")> ,o.Oficodigo </cfif>
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
						,sum(s.DOdebitos) as debitos, sum(s.COcreditos)as creditos 
					<cfelse>
						,sum(s.DLdebitos) as debitos, sum(s.CLcreditos)as creditos 
					</cfif> 								
					from #cubo2# cu 
						inner join SaldosContables s
						on  s.Ccuenta  = cu.Ccuenta
						and s.Speriodo = cu.Speriodo
						and s.Smes    >= cu.Smes1
						and s.Smes    <= cu.Smes2
						<cfif isdefined("form.ID_incsucursal") >
							inner join Oficinas o <cf_dbforceindex name="PK_OFICINAS">
								 on o.Ecodigo = s.Ecodigo
								and o.Ocodigo = s.Ocodigo
						</cfif>
					where cu.Ccuentaniv = #LvarCcuentaniv#
					  and <cfif Empresa eq true> s.Ecodigo in (#ListaEmpresas#) <cfelse> s.Ecodigo =  #session.Ecodigo# </cfif>
					  and  s.Speriodo   =  #LvarPeriodo#
					<cfif LvarSoloMes>
					  and  s.Smes       = #LvarMesInicial#
					<cfelse>
					  and  s.Smes      >= #LvarMesInicial#
					  and  s.Smes      <= #LvarMesFinal#
					</cfif>
					<cfif Oficina eq true>
					  and s.Ocodigo in (#ListaOficinas#)
					</cfif>	
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
					  and s.Mcodigo = #form.Mcodigo#
					</cfif>
					group by  s.Smes  <cfif isdefined("form.ID_incsucursal")>, o.Oficodigo </cfif>
					order by  s.Smes  <cfif isdefined("form.ID_incsucursal")>, o.Oficodigo </cfif>
				</cfquery>
			<cfelse>
				<cfquery name="rsDetalle" datasource="#session.dsn#">
					select 
						#LvarPeriodo# as Speriodo, a.Emes as Smes <cfif isdefined("form.ID_incsucursal")>	,o.Oficodigo </cfif>
						<cfif TipoFormato eq 1>	,a.Cconcepto ,a.Edocumento </cfif>
						<cfif TipoFormato eq 3> ,a.Cconcepto </cfif>
						<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
							,sum(case Dmovimiento when 'D'  then Doriginal  else 0 end) as debitos 
							,sum(case Dmovimiento when 'C'  then Doriginal  else 0 end) as creditos 								
						<cfelse>
							,sum(case Dmovimiento when 'D'  then Dlocal  else 0 end) as debitos 
							,sum(case Dmovimiento when 'C'  then Dlocal  else 0 end)as creditos 								
						</cfif>
					from #cubo2# cu 
						inner join HDContables a <cf_dbforceindex name="HDContables_Index1">
							<cfif isdefined("form.ID_incsucursal") >
							inner join Oficinas o <cf_dbforceindex name="PK_OFICINAS">
								 on o.Ecodigo    = a.Ecodigo
								and o.Ocodigo    = a.Ocodigo
							</cfif>
						 on  a.Ccuenta    = cu.Ccuenta
						 and a.Eperiodo   = cu.Speriodo
						<cfif LvarSoloMes>
						  and a.Emes     = #LvarMesInicial#
						  and a.Emes     = cu.Smes1
						<cfelse>
						  and a.Emes    >= #LvarMesInicial#
						  and a.Emes    <= #LvarMesFinal#
						  and a.Emes    >= cu.Smes1
						  and a.Emes    <= cu.Smes2
						</cfif>

						inner join HEContables ea
						 on ea.IDcontable = a.IDcontable

					where cu.Ccuentaniv = #LvarCcuentaniv#
					  and <cfif Empresa eq true> a.Ecodigo in (#ListaEmpresas#) <cfelse> a.Ecodigo =  #session.Ecodigo# </cfif>
					  and a.Eperiodo = #LvarPeriodo#
					<cfif LvarSoloMes>
					  and a.Emes     = #LvarMesInicial#
					<cfelse>
					  and a.Emes    >= #LvarMesInicial#
					  and a.Emes    <= #LvarMesFinal#
					</cfif>
					<cfif not isdefined("chkAstCierre")>
					  and ea.ECtipo     <> 1
					</cfif>
					  and ea.Eperiodo   = a.Eperiodo
					  and ea.Emes       = a.Emes
					<cfif len(trim(ListaAsientos)) GT 0>
					  and  a.Cconcepto in (#ListaAsientos#)
					</cfif>
					<cfif Oficina eq true>
					  and a.Ocodigo in (#ListaOficinas#)
					</cfif>
					<cfif isdefined("form.Mcodigo") and  len(trim(form.Mcodigo))>
					  and a.Mcodigo = #form.Mcodigo#
					</cfif>

					group by 
						a.Emes <cfif isdefined("form.ID_incsucursal")> ,o.Oficodigo </cfif>
						<cfif TipoFormato eq 1>	,a.Cconcepto ,a.Edocumento </cfif>
						<cfif TipoFormato eq 3> ,a.Cconcepto </cfif>
					order by 
						a.Emes <cfif isdefined("form.ID_incsucursal")> ,o.Oficodigo </cfif>
						<cfif TipoFormato eq 1>	,a.Cconcepto ,a.Edocumento </cfif>
						<cfif TipoFormato eq 3> ,a.Cconcepto </cfif>
				</cfquery>	
			</cfif>
			<cfif  isdefined("rsDetalle") and rsDetalle.RecordCount GT 0 >
				<cfsavecontent variable="micontenido">
				<tr>
					<td nowrap>&nbsp;</td>
					<td nowrap  align="right" colspan="4">
						<table width="80%" cellpadding="0" cellspacing="0" border="1" >
						<tr>
						<cfswitch expression="#TipoFormato#">
							<cfcase value="1"><!--- Detallado por Consecutivo --->
								<cfif isdefined("form.ID_incsucursal") ><td nowrap width="10%" align="right" class="xl25">#LB_Oficina#</td></cfif>
                                <cfoutput>
								<td nowrap  width="10%" align="right" class="xl25">#LB_Periodo#</td>
								<td nowrap  width="10%" align="right" class="xl25">#LB_Mes#</td>
								<td nowrap  width="10%" align="right" class="xl25">#LB_Asiento#</td>
								<td nowrap  width="10%" align="right" class="xl25">#LB_Consecutivo#</td>
								<td nowrap  width="20%" align="right" class="xl25">#LB_Debitos#</td>
								<td nowrap  width="20%" align="right" class="xl25">#LB_Creditos#</td>
                                </cfoutput>
							</cfcase>
							<cfcase value="2"><!--- Detallado por Mes --->
								<cfif isdefined("form.ID_incsucursal") ><td nowrap width="10%" align="right" class="xl25">#LB_Oficina#</td></cfif>
                                <cfoutput>
								<td nowrap  width="20%" align="right" class="xl25">#LB_Periodo#</td>
								<td nowrap  width="20%" align="right" class="xl25">#LB_Mes#</td>
								<td nowrap  width="20%" align="right" class="xl25">#LB_Debitos#</td>
								<td nowrap  width="20%"align="right" class="xl25">#LB_Creditos#</td>
                                </cfoutput>
							</cfcase>
							<cfcase value="3"><!--- Detallado por Asiento--->
								<cfif isdefined("form.ID_incsucursal") ><td nowrap  width="10%" align="right" class="xl25">#LB_Oficina#</td></cfif>
                                <cfoutput>
								<td nowrap  width="10%" align="right" class="xl25">#LB_Periodo#</td>
								<td nowrap  width="10%" align="right" class="xl25">#LB_Mes#</td>
								<td nowrap  width="20%" align="right" class="xl25">#LB_Asiento#</td>
								<td nowrap  width="20%"align="right" class="xl25">#LB_Debitos#</td>
								<td nowrap  width="20%"align="right" class="xl25">#LB_Creditos#</td>
                                </cfoutput>
							</cfcase>
						</cfswitch>	
						</tr>	
				</cfsavecontent>
				<cfset fnGraba(micontenido, true, false)>
				<cfloop query="rsDetalle">
					<cfsavecontent variable="micontenido">
					<cfoutput>
					<tr>
						<cfif isdefined("form.ID_incsucursal") ><td nowrap align="right" class="xl29">#rsDetalle.Oficodigo#</td></cfif>
						<td nowrap align="right" class="xl28">#rsDetalle.Speriodo#</td>
						<td nowrap align="right" class="xl28">#rsDetalle.Smes#</td>
						<cfswitch expression="#TipoFormato#">
						<cfcase value="1"><!--- Detallado por Consecutivo --->
							<td nowrap align="right" class="xl28">#rsDetalle.Cconcepto#</td>														
							<td nowrap align="right" class="xl28">#rsDetalle.Edocumento#</td>														
						</cfcase>
						<cfcase value="3"><!--- Detallado por Asiento--->
							<td nowrap align="right" class="xl28">#rsDetalle.Cconcepto#</td>														
						</cfcase>
						</cfswitch>	
						<td nowrap align="right" class="x_l28">#LSCurrencyFormat(rsDetalle.debitos,'none')#</td>
						<td nowrap align="right" class="x_l28">#LSCurrencyFormat(rsDetalle.creditos,'none')#</td>
					</tr>
					</cfoutput>
					</cfsavecontent>
					<cfset fnGraba(micontenido, true, false)>
				</cfloop>
				<cfsavecontent variable="micontenido">
						</table>	
					</td>	
				</tr>				
				</cfsavecontent>
				<cfset fnGraba(micontenido, true, false)>
			</cfif>
		</cfif>
	</cfloop>
	<cfsavecontent variable="micontenido">
	</table>
	<table width="100%" cellpadding="0" cellspacing="0" border="1" >
    	<cfoutput>
		<tr>
			<td colspan="6" align="center" class="xl25">#LB_Parametros#</td>
		</tr>
		<tr>
			<td colspan="2" align="left" class="xl25">#LB_Cuentas#:</td>
			<td colspan="2" align="left" class="xl25">#LB_Oficinas#:</td>
			<td colspan="2" align="left" class="xl25">#LB_Empresas#:</td>
        </tr></cfoutput>    
		
		<tr>
			<td colspan="2" align="left" valign="top"   class="xl28"><cfoutput>#Pcuentas#</cfoutput></td>
			<td colspan="2" align="left" valign="top"   class="xl28"><cfoutput>#POficinas#</cfoutput></td>
			<td colspan="2" align="left" valign="top"   class="xl28"><cfoutput>#PEmpresas#</cfoutput></td>
		</tr>	
	</table>
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, true)> 
</cffunction>
<cffunction name="fnGraba" output="no">
	<cfargument name="contenido" required="yes">
	<cfargument name="paraExcel" required="no" default="yes">
	<cfargument name="fin" required="no" default="no">

	<cfset contenido = replace(contenido,"   "," ","All")>
	<cfset contenido = REReplace(contenido,'([ \t\r\n])+',' ','all')>
	<cfset contenidohtml = contenidohtml & contenido>
	<cfif len(contenidohtml) GTE 131072>
		<cffile action="append" file="#tempfile_xls#" output="#contenidohtml#">
		<cfset contenidohtml = "">
	</cfif>
	<cfif fin>
		<cffile action="append" file="#tempfile_xls#" output="#contenidohtml#">
		<cfset contenidohtml = "">
	</cfif>
</cffunction>
