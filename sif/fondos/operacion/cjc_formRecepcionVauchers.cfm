<!--- Pasa los parametros para utilizar la navegacion --->
<cfif isdefined("url.PERCOD") and LEN(url.PERCOD)>
	<cfset form.PERCOD = url.PERCOD>
</cfif>
<cfif isdefined("url.MESCODI") and LEN(url.MESCODI)>
	<cfset form.MESCODI = url.MESCODI>
</cfif>
<cfif isdefined("url.MESCODF") and LEN(url.MESCODF)>
	<cfset form.MESCODF = url.MESCODF>
</cfif>
<cfif isdefined("url.CJX12IRC") and LEN(url.CJX12IRC)>
	<cfset form.CJX12IRC = url.CJX12IRC>
</cfif>	
<cfif isdefined("url.DIA_RETRAZO") and LEN(url.DIA_RETRAZO)>
	<cfset form.DIA_RETRAZO = url.DIA_RETRAZO>
</cfif>	
<cfif isdefined("url.ORDENAR") and LEN(url.ORDENAR)>
	<cfset form.ORDENAR = url.ORDENAR>
</cfif>
<cfif isdefined("url.EMPCOD1") and LEN(url.EMPCOD1)>
	<cfset form.EMPCOD1 = url.EMPCOD1>
</cfif>	
<cfif isdefined("url.Fechafiltro") and LEN(url.Fechafiltro)>
	<cfset form.Fechafiltro = url.Fechafiltro>
</cfif>
<cfif isdefined("url.TR01NUT1") and LEN(url.TR01NUT1)>
	<cfset form.TR01NUT1 = url.TR01NUT1>
</cfif>
<cfif isdefined("url.CJX12AUT") and LEN(url.CJX12AUT)>
	<cfset form.CJX12AUT = url.CJX12AUT>
</cfif>
<cfif isdefined("url.CANTIDAD") and LEN(url.CANTIDAD)>
	<cfset form.CANTIDAD = url.CANTIDAD>
</cfif>

<cfinclude template="encabezadofondos.cfm">

<script language='javascript' src='/js/global.js'></script>
<script language='javascript' src='/js/overlib.js'></script>

<cfset modo="ALTA">
<cfif isdefined("btnFiltrar")>
	<cfset modo="CAMBIO">
</cfif>

<form name="form1" action="../operacion/cjc_RecepcionVauchers.cfm" method="post">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td  align="left" colspan="2" >
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
							<tr>
								<td class="barraboton">&nbsp;
									<a id ='CONSULTAR' href="javascript: Consultar(); " onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
									<a id ='LIMPIAR' href="javascript: Limpiar(); " onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>									
									<a id ='APLICAR' href="javascript: Aplicar(); " onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;<cfif not isdefined("CJX12IRC") or ( isdefined("CJX12IRC") and len(trim(CJX12IRC)) neq 0 and CJX12IRC eq 0)>Recibir<cfelse>Rechazar</cfif>&nbsp;</span></a>
								</td>
								<td class="barraboton">
									<p align=center><font color='#FFFFFF'><b> </b></font></p>
								</td>
							</tr>
						</table>					
						<input type="hidden" id="btnFiltrar" name="btnFiltrar">
					</td>
				</tr>
			</table>			
		</td>
	</tr>

	<tr>
		<td>
			<table  border="0" cellspacing="1" cellpadding="1" width="100%">
				<cfquery name="rsFondo" datasource="#session.Fondos.dsn#">
					select CJM00COD,CJM00DES 
					from CJM000 
					where CJM00COD = <cfqueryparam cfsqltype="cf_sql_char" value="#session.fondos.fondo#">				
				</cfquery>
				<tr>
					<td width="15%">Fondo de Caja</td>			
					<td colspan="4" width="75%">
						<INPUT TYPE="textbox" 
							NAME="CJM00COD1" 
							ID  ="CJM00COD1"
							VALUE="<cfif isdefined('rsFondo.CJM00COD')><cfoutput>#session.fondos.fondo#</cfoutput></cfif>" 
							SIZE="5" 
							MAXLENGTH="4"
							style="visibility; border:none; color:blue; background-color:white;" 
							readonly >
						&nbsp;&nbsp;		
						<cfoutput><font style="color:blue; ">#rsFondo.CJM00DES#</font></cfoutput>
					</td>
				</tr>
				
				<tr>
					<td width="15%">Periodo</TD>
			  		<td width="25%">
						<cfquery datasource="#session.Fondos.dsn#" name="rsPeriodo">
							Select PERCOD
							from CGX051
							order by PERCOD
						</cfquery>
			
						<cfif not isdefined("form.PERCOD")>
							<cfset form.PERCOD = year(now())>							
						</cfif>
                       	
						<select name="PERCOD" size="1" style="font-size:8pt;  font-family: Courier New;" tabindex="1">
                       		<cfoutput query="rsPeriodo">
                           		<option value="#PERCOD#" 
									<cfif isdefined("form.PERCOD") and isdefined("rsPeriodo") 
									and len(form.PERCOD) and len(rsPeriodo.PERCOD)
					  				and form.PERCOD eq rsPeriodo.PERCOD>selected</cfif>>
									#PERCOD#
								</option>
                       		</cfoutput>
                       	</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Mes Inicial</td>
					<td width="25%">
						<cfif not isdefined("form.MESCODI")>
							<cfset form.MESCODI = month(now())>
						</cfif>
				
						<select name="MESCODI" size="1" style="font-size:8pt;  font-family: Courier New;" tabindex="2">
							<cfloop from="1" to="12" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.MESCODI") and len(form.MESCODI) and form.MESCODI eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput><cfif indmes lt 10>&nbsp;</cfif>&nbsp;-
									<cfswitch expression="#indmes#">
										<cfcase value="1">ENERO</cfcase>
										<cfcase value="2">FEBRERO</cfcase>
										<cfcase value="3">MARZO</cfcase>
										<cfcase value="4">ABRIL</cfcase>
										<cfcase value="5">MAYO</cfcase>
										<cfcase value="6">JUNIO</cfcase>
										<cfcase value="7">JULIO</cfcase>
										<cfcase value="8">AGOSTO</cfcase>
										<cfcase value="9">SETIEMBRE</cfcase>
										<cfcase value="10">OCTUBRE</cfcase>
										<cfcase value="11">NOVIEMBRE</cfcase>
										<cfcase value="12">DICIEMBRE</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>
					</td>
				</tr>		
			
				<tr>
					<td width="15%">Empleado </td>
					<td width="25%">
						<cfif isdefined("form.EMPCOD1")>
							<cfquery name="rsEmpleado" datasource="#session.Fondos.dsn#">
								select  EMPCED AS EMPCED1,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE,EMPCOD as EMPCOD1 
								from PLM001 
								where  EMPCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EMPCOD1#" >
							</cfquery>						
						
							<cf_cjcConlis 	
									size		="30"  
									name 		="EMPCED1" 
									desc 		="NOMBRE" 
									id			="EMPCOD1" 
									desc2		="TR01NUT1"
									cjcConlisT 	="cjc_traeEmpVoucher"
									query       ="#rsEmpleado#"
									form		="form1"
									tabindex    ="3"
							>			
						<cfelse>
							<cf_cjcConlis 	
									size		="30"  
									name 		="EMPCED1" 
									desc 		="NOMBRE" 
									id			="EMPCOD1" 
									desc2		="TR01NUT1"
									cjcConlisT 	="cjc_traeEmpVoucher"
									form   		="form1"
									tabindex    ="3"
							>
						</cfif>				
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Mes Final </td>
					<td width="25%">
						<cfif not isdefined("form.MESCODF")>
							<cfset form.MESCODF = month(now())>
						</cfif>
				
						<select name="MESCODF" size="1" style="font-size:8pt;  font-family: Courier New;" tabindex="4">
							<cfloop from="1" to="12" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.MESCODF") and len(form.MESCODF) and form.MESCODF eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput><cfif indmes lt 10>&nbsp;</cfif>&nbsp;-
									<cfswitch expression="#indmes#">
										<cfcase value="1">ENERO</cfcase>
										<cfcase value="2">FEBRERO</cfcase>
										<cfcase value="3">MARZO</cfcase>
										<cfcase value="4">ABRIL</cfcase>
										<cfcase value="5">MAYO</cfcase>
										<cfcase value="6">JUNIO</cfcase>
										<cfcase value="7">JULIO</cfcase>
										<cfcase value="8">AGOSTO</cfcase>
										<cfcase value="9">SETIEMBRE</cfcase>
										<cfcase value="10">OCTUBRE</cfcase>
										<cfcase value="11">NOVIEMBRE</cfcase>
										<cfcase value="12">DICIEMBRE</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>					
					</td>			
				</tr>
		
				<tr>
					<td width="15%">No. de Tarjeta</td>
					<td width="25%">
						<INPUT TYPE="textbox" 
							NAME="TR01NUT1" 
							ID  ="TR01NUT1"
							VALUE="<cfif isdefined('TR01NUT1')><cfoutput>#TR01NUT1#</cfoutput></cfif>" 
							SIZE="20" 
							MAXLENGTH="20" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="visibility: " 
							tabindex="5">		
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Fecha Recepci&oacute;n</td>
					<td width="25%">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<cfif isdefined("form.CJX12IRC")>
								<cfif trim(form.CJX12IRC) EQ 1>
									<tr id="tr_fecha" >
								<cfelse>
									<tr id="tr_fecha" style="display: none">
								</cfif>
							<cfelse>
								<tr id="tr_fecha" style="display: none">
							</cfif>
								<td>
									<cfif isdefined("Fechafiltro")>
										<cfset F_FINAL = #Fechafiltro#>
									<cfelse>
										<cfset F_FINAL = "">
									</cfif>
									<cf_CJCcalendario tabindex="6" name="Fechafiltro" form="form1" value="#F_FINAL#">
								</td>
							</tr>
							<cfif isdefined("form.CJX12IRC")>
								<cfif trim(form.CJX12IRC) EQ 1>
									<tr id="tr_campo" style="display: none">
								<cfelse>
									<tr id="tr_campo" >
								</cfif>
							<cfelse>
								<tr id="tr_campo" >
							</cfif>
								<td>
									<INPUT TYPE="textbox" 
										NAME="FECHA" 
										VALUE="" 
										SIZE="10" 
										MAXLENGTH="10" 
										tabindex="6"
										DISABLED >
								</td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr>
					<td width="15%">Estado</td>
					<td width="25%">
						<cfif not isdefined("form.CJX12IRC")>
							<cfset form.CJX12IRC = "0">
						</cfif>
							
						<select name="CJX12IRC" size="1" style="font-size:8pt;  font-family: Courier New;" tabindex="7" onchange="javascript: HabilitarFecha(this.value)">
							<cfloop from="0" to="1" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.CJX12IRC") and len(form.CJX12IRC) and form.CJX12IRC eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput>&nbsp;-
									<cfswitch expression="#indmes#">																				
										<cfcase value="0">Pendientes</cfcase>
										<cfcase value="1">Recibidas</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">No. Autorizaci&oacute;n</td>
					<td width="25%">
						<input type="textbox"  
							name="CJX12AUT" 
							id  ="CJX12AUT"
							value="<cfif isdefined("CJX12AUT")><cfoutput>#CJX12AUT#</cfoutput></cfif>" 
							size= "20" 
							maxlength="20" 					
							onFocus="this.select(); " 
							onKeyUp="" 
							style="visibility:" 
							tabindex="8" >
						
					</td>
				</tr>
				
				<tr>
					<td width="15%">Ordenar Datos Por </td>
					<td width="25%">
						<cfif not isdefined("form.ORDENAR")>
							<cfset form.ORDENAR = "1">
						</cfif>	

						<select name="ORDENAR" size="1" style="font-size:8pt;  font-family: Courier New;" tabindex="9">
							<cfloop from="1" to="9" step="1" index="indmes">
								<option value="<cfoutput>#indmes#</cfoutput>" <cfif isdefined("form.ORDENAR") and len(form.ORDENAR) and form.ORDENAR eq indmes>selected</cfif>>
									<cfoutput>#indmes#</cfoutput>&nbsp;-
									<cfswitch expression="#indmes#">
										<cfcase value="1">Fecha Voucher</cfcase>
										<cfcase value="2">C&eacute;dula</cfcase>
										<cfcase value="3">Autorizaci&oacute;n</cfcase>
										<cfcase value="4">No. Tarjeta</cfcase>
										<cfcase value="5">Monto</cfcase>
										<cfcase value="6">Empleado</cfcase>
										<cfcase value="7">Tipo Voucher</cfcase>
										<cfcase value="8">D&iacute;as Atraso</cfcase>
										<cfcase value="9">Fecha Recepci&oacute;n</cfcase>
									</cfswitch>
								</option>
							</cfloop>			
						</select>
					</td>
					<td width="10%">&nbsp;</td>	
					<td width="15%">D&iacute;as Atraso</td>			
					<td width="25%">
						<cfif not isdefined("form.DIA_RETRAZO")>
							<cfset form.DIA_RETRAZO = "3">
						</cfif>	
						<select name="DIA_RETRAZO" size="1" style="font-size:8pt;  font-family: Courier New;" tabindex="10">
							<option value="1" <cfif isdefined("form.DIA_RETRAZO") and len(form.DIA_RETRAZO) and form.DIA_RETRAZO eq 1>selected</cfif>>1 a 8 d&iacute;as</option>
							<option value="2" <cfif isdefined("form.DIA_RETRAZO") and len(form.DIA_RETRAZO) and form.DIA_RETRAZO eq 2>selected</cfif>>8 a 15 d&iacute;as</option>
							<option value="3" <cfif isdefined("form.DIA_RETRAZO") and len(form.DIA_RETRAZO) and form.DIA_RETRAZO eq 3>selected<cfelse>selected </cfif>>- Todos -</option>
						</select>
					</td>									
				</tr>
				
				<tr>
					<td width="15%">Cantidad Registros</td>
					<td width="25%">
						<cfif not isdefined("form.CANTIDAD")>
							<cfset form.CANTIDAD = 500>
						</cfif>						
						<input type="textbox"
							name="CANTIDAD" 
							id  ="CANTIDAD"
							value="<cfif isdefined('CANTIDAD')><cfoutput>#CANTIDAD#</cfoutput></cfif>"
							size= "5" 
							maxlength="4" 					
							onFocus="this.select(); " 
							onKeyUp="" 
							style="text-align:right; visibility: "
							tabindex="11">					
					</td>
					<td width="10%">&nbsp;</td>	
					<td width="15%">&nbsp;</td>			
					<td width="25%">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>

</table>
</form>

<form name="form2" method="post">
<input type="hidden" name="CJX12IRC" value="<cfif isdefined("CJX12IRC") and len(trim(CJX12IRC)) neq 0><cfoutput>#CJX12IRC#</cfoutput><cfelse>0</cfif>">
<input type="hidden" name="MESCODI" value="<cfif isdefined("MESCODI") and len(trim(MESCODI)) neq 0><cfoutput>#MESCODI#</cfoutput></cfif>">
<input type="hidden" name="MESCODF" value="<cfif isdefined("MESCODF") and len(trim(MESCODF)) neq 0><cfoutput>#MESCODF#</cfoutput></cfif>">
<input type="hidden" name="PERCOD" value="<cfif isdefined("PERCOD") and len(trim(PERCOD)) neq 0><cfoutput>#PERCOD#</cfoutput></cfif>">
<input type="hidden" name="CJX12AUT" value="<cfif isdefined("CJX12AUT") and len(trim(CJX12AUT)) neq 0><cfoutput>#CJX12AUT#</cfoutput></cfif>">
<input type="hidden" name="DIA_RETRAZO" value="<cfif isdefined("DIA_RETRAZO") and len(trim(DIA_RETRAZO)) neq 0><cfoutput>#DIA_RETRAZO#</cfoutput></cfif>">
<input type="hidden" name="ORDENAR" value="<cfif isdefined("ORDENAR") and len(trim(ORDENAR)) neq 0><cfoutput>#ORDENAR#</cfoutput></cfif>">
<input type="hidden" name="EMPCOD1" value="<cfif isdefined("EMPCOD1") and len(trim(EMPCOD1)) neq 0><cfoutput>#EMPCOD1#</cfoutput></cfif>">
<input type="hidden" name="Fechafiltro" value="<cfif isdefined("Fechafiltro") and len(trim(Fechafiltro)) neq 0><cfoutput>#Fechafiltro#</cfoutput></cfif>">
<input type="hidden" name="TR01NUT1" value="<cfif isdefined("TR01NUT1") and len(trim(TR01NUT1)) neq 0><cfoutput>#TR01NUT1#</cfoutput></cfif>">
<input type="hidden" name="CANTIDAD" value="<cfif isdefined("CANTIDAD") and len(trim(CANTIDAD)) neq 0><cfoutput>#CANTIDAD#</cfoutput></cfif>">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfset modo="CAMBIO">
			<!--- Consulta todos los datos de la 12 que coinciden con los filtros y no estan conciliados --->
			<cfset filtro = "">	
			<cfset navegacion = "?modo=#modo#">
		
			<cfoutput>
				<!--- Filtro por Periodo --->		
				<cfif isdefined("PERCOD") and len(PERCOD)>
					<cfset filtro = filtro & " and a.PERCOD = #PERCOD#">
					<cfset navegacion = navegacion & "&PERCOD=#PERCOD#">
				</cfif>
				<!--- Filtro por Mes Inicial --->
				<cfif isdefined("MESCODI") and len(MESCODI)>
					<cfset filtro = filtro & " and a.MESCOD >= #MESCODI#">	
					<cfset navegacion = navegacion & "&MESCODI=#MESCODI#">
				</cfif>
				<!--- Filtro por Mes Final --->
				<cfif isdefined("MESCODF") and len(MESCODF)>
					<cfset filtro = filtro & " and a.MESCOD <= #MESCODF#">	
					<cfset navegacion = navegacion & "&MESCODF=#MESCODF#">
				</cfif>
				<!--- Filtro por Cédula Empleado --->
				<cfif isdefined("EMPCED1") and len(EMPCED1)>
					<cfset navegacion = navegacion & "&EMPCED1=#EMPCED1#">
				</cfif>
				<!--- Filtro por Código Empleado --->
				<cfif isdefined("EMPCOD1") and len(EMPCOD1)>					
					<cfset navegacion = navegacion & "&EMPCOD1=#EMPCOD1#">
				</cfif>
				<!--- Filtro por Fecha Recepción --->
				<cfif isdefined("form.CJX12IRC") and trim(form.CJX12IRC) EQ 1>
					<cfif isdefined("Fechafiltro") and len(Fechafiltro)>
						<cfset filtro = filtro & " and a.CJX12FRC between '#LSdateformat(Fechafiltro,"yyyymmdd")#' and '#LSdateformat(Fechafiltro,"yyyymmdd")# 11:59:59 PM'">	
						<cfset navegacion = navegacion & "&Fechafiltro=#Fechafiltro#">
					</cfif>
				</cfif>
				<!--- Filtro por Tarjeta --->
				<cfif isdefined("TR01NUT1") and len(TR01NUT1)>
					<cfset filtro = filtro & " and a.TR01NUT like '%#TR01NUT1#%'">
					<cfset navegacion = navegacion & "&TR01NUT1=#TR01NUT1#">
				</cfif>
				<!--- Filtro por Autorización --->
				<cfif isdefined("CJX12AUT") and len(CJX12AUT)>
					<cfset filtro = filtro & " and a.CJX12AUT like '%#CJX12AUT#%'">
					<cfset navegacion = navegacion & "&CJX12AUT=#CJX12AUT#">
				</cfif>
				<!--- Filtro por Estado --->
				<cfif isdefined("CJX12IRC") and len(CJX12IRC)>
					<cfif CJX12IRC eq 0 >
						<cfset filtro = filtro & " and (a.CJX12IRC is null or a.CJX12IRC != 1)">
					</cfif>					
					<cfif CJX12IRC eq 1 >
						<cfset filtro = filtro & " and a.CJX12IRC = 1">
					</cfif>
					<cfset navegacion = navegacion & "&CJX12IRC=#CJX12IRC#">
				</cfif>
				<!--- Filtro por Días de Retraso --->
				<cfif isdefined("DIA_RETRAZO") and len(DIA_RETRAZO)>
					<cfif DIA_RETRAZO eq 1 >
						<cfset filtro = filtro & " and datediff(dd,a.CJX12FEC,getdate()) between 1 and 8 ">
					</cfif>
					<cfif DIA_RETRAZO eq 2 >
						<cfset filtro = filtro & " and datediff(dd,a.CJX12FEC,getdate()) between 8 and 15 ">
					</cfif>
					<cfif DIA_RETRAZO eq 3 >
						<cfset filtro = filtro & " and datediff(dd,a.CJX12FEC,getdate()) >= 15 ">
					</cfif>
					<cfset navegacion = navegacion & "&DIA_RETRAZO=#DIA_RETRAZO#">
				</cfif>
				<!--- Filtro por Ordenamiento --->
				<cfif isdefined("ORDENAR") and len(ORDENAR)>
					<cfif ORDENAR eq 1 >
						<cfset filtro = filtro & " order by a.CJX12FAU ">
					</cfif>					
					<cfif ORDENAR eq 2 >
						<cfset filtro = filtro & " order by a.EMPCED ">
					</cfif>
					<cfif ORDENAR eq 3 >
						<cfset filtro = filtro & " order by a.CJX12AUT ">
					</cfif>
					<cfif ORDENAR eq 4 >
						<cfset filtro = filtro & " order by a.TR01NUT ">
					</cfif>
					<cfif ORDENAR eq 5 >
						<cfset filtro = filtro & " order by a.CJX12IMP ">
					</cfif>
					<cfif ORDENAR eq 6 >
						<cfset filtro = filtro & " order by a.EMPNOM ">
					</cfif>
					<cfif ORDENAR eq 7 >
						<cfset filtro = filtro & " order by a.CJX12TIP ">
					</cfif>
					<cfif ORDENAR eq 8 >
						<cfset filtro = filtro & " order by a.DIAS_DIF desc">
					</cfif>
					<cfif ORDENAR eq 9 >
						<cfset filtro = filtro & " order by a.CJX12FRC desc">
					</cfif>

					<cfset navegacion = navegacion & "&ORDENAR=#ORDENAR#">
				</cfif>
				<!--- Filtro por Cantidad de Registros --->
				<cfif isdefined("CANTIDAD") and len(CANTIDAD)>					
					<cfset navegacion = navegacion & "&CANTIDAD=#CANTIDAD#">
				</cfif>
								
			</cfoutput>

			<!--- <cfdump var="#filtro#"> --->
			
			<cfinvoke 
				component="sif.fondos.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet">
				<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
				<cfinvokeargument name="tabla" value="	CJX012 a
															inner join CATR01 b
																on a.TS1COD = b.TS1COD
																and a.TR01NUT = b.TR01NUT"/>
				<cfinvokeargument name="columnas" value=" 
														a.TR01NUT,
														case a.CJX12TIP 
															when 1 then 'Compras'
															when 2 then 'Avance de efectivo'
															when 3 then 'Pago Recibido'
															when 4 then 'Reversion de pago'
															when 5 then 'Reversion de Avance de efectivo'
															when 6 then 'Reintegro de la Linea de Pago'
															when 7 then 'Reversion de Compras'
														end as CJX12TIP,
														a.CJX12AUT, 
														convert(varchar,a.CJX12FAU,103) as CJX12FAU,
														convert(varchar,a.CJX12FEC,103) as CJX12FEC, 														 
														(select EMPCED 
														 from PLM001 p 
														 where p.EMPCOD = b.EMPCOD) as EMPCED, 
														(select EMPAPA ||' '|| EMPAMA ||' '|| EMPNOM
														 from PLM001 p 
														 where p.EMPCOD = b.EMPCOD) as EMPNOM, 
														a.CJX12IMP,
														a.TS1COD,
														a.PERCOD, 
														a.MESCOD,
														datediff(dd,a.CJX12FEC,getdate()) as DIAS_DIF,
														convert(varchar,a.CJX12FRC,103) as CJX12FRC,
														a.CJX12URC	"/>

				<cfif isdefined("CJX12IRC") and trim(CJX12IRC) EQ 0>
					<cfinvokeargument name="desplegar" value="TR01NUT,CJX12TIP,CJX12AUT,CJX12FAU,EMPCED,EMPNOM,CJX12IMP,DIAS_DIF"/>
					<cfinvokeargument name="etiquetas" value="No. Tarjeta,Tipo Voucher,Autorizaci&oacute;n,Fecha Voucher,C&eacute;dula, Empleado,Monto,Dias Atraso"/>
					<cfinvokeargument name="formatos" value="S,S,S,S,S,S,M,S"/>	
					<cfinvokeargument name="align" value="left,left,left,left,left,left,right,center"/>

				<cfelse>
					<cfinvokeargument name="desplegar" value="TR01NUT,CJX12TIP,CJX12AUT,CJX12FAU,EMPCED,EMPNOM,CJX12IMP,DIAS_DIF,CJX12FRC,CJX12URC"/>
					<cfinvokeargument name="etiquetas" value="No. Tarjeta,Tipo Voucher,Autorizaci&oacute;n,Fecha Voucher,C&eacute;dula, Empleado,Monto,Dias Atraso,Fecha Recepci&oacute;n,Usuario"/>
					<cfinvokeargument name="formatos" value="S,S,S,S,S,S,M,S,S,S"/>															
					<cfinvokeargument name="align" value="left,left,left,left,left,left,right,center,left,left"/>
				</cfif>
				<!--- <cfinvokeargument name="filtro" value=" CJM00COD = '201' and TS1COD = 'TP' #filtro#"/>  --->
				<cfinvokeargument name="filtro" value=" a.CJM00COD = '#session.fondos.fondo#' and a.TS1COD = 'TP' #filtro#"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="incluyeForm" value="false"/>				
				<cfinvokeargument name="keys" value="TS1COD, TR01NUT, CJX12AUT, CJX12FEC, PERCOD, MESCOD"/>
				<cfinvokeargument name="irA" value="cjc_RecepcionVauchers.cfm"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="rowCount" value="#CANTIDAD#"/>
			</cfinvoke>
			
		</td>
	</tr>
</table>

</form>

<script>
	function Consultar() {
		if (ValidarRegistros()) {
			document.form1.submit();
		}
	}
	
	function Limpiar() {
		document.location = '../operacion/cjc_RecepcionVauchers.cfm';
	}
	
	function Aplicar() {				
		<cfif isdefined("pListaRet")>
			if (ValidaChecks()) {
				document.form2.action = "cjc_sqlRecepcionVauchers.cfm";
				document.form2.submit();
			}
			else {
				alert("Es necesario seleccionar al menos un voucher");
			}
		<cfelse>
			alert("Es necesario seleccionar al menos un voucher");
		</cfif>
	}
	
	function listatarjetas(dato) {
		var formato   = "left=400,top=250,scrollbars=yes,resizable=yes,width=450,height=200"
		var direccion = "/cfmx/sif/fondos/Utiles/cjc_tarjetasVoucher.cfm?dato="+dato
		open(direccion,"",formato);	
	}
	
	function ValidaChecks() {		
		<cfif isdefined("pListaRet") and pListaRet neq 0>
			<cfif isdefined("pListaRet") and pListaRet eq 1>				
				if (document.form2.chk.checked == true) {
					return true;
				}
				return false;
			<cfelse>
				var field = document.form2.chk;		
				for (i = 0; i < field.length; i++) {
					if (field[i].checked == true) {	
						return true;
					}
				}
				return false;
			</cfif>
		<cfelse>
			return false;
		</cfif>
	}
	
	function ValidarRegistros() {
		if (document.form1.CANTIDAD.value < 1 ) {
			alert("La Cantidad de Registros no puede ser menor o igual a 0.");
			document.form1.CANTIDAD.focus();
			return false;
		}
		
		if (document.form1.CANTIDAD.value > 3000) {
			alert("La Cantidad de Registros no puede ser mayor a 3000.");
			document.form1.CANTIDAD.focus();
			return false;
		}
		return true;
	}
	
	function HabilitarFecha(valor) {
		var vFecha = document.getElementById("tr_fecha");
		var vCampo = document.getElementById("tr_campo");

		if (valor == 0) {
			vFecha.style.display = "none";			
			vCampo.style.display = "";
		}
		else {
			vFecha.style.display = "";			
			vCampo.style.display = "none";			
		}
	}
	
</script>

