<cfinclude template="encabezadofondos.cfm">

<script language='javascript' src='/js/global.js'></script>
<script language='javascript' src='/js/overlib.js'></script>

<cfset modo="ALTA">
<cfif isdefined("btnFiltrar")>
	<cfset modo="CAMBIO">
</cfif>



<form name="form1" action="../operacion/cjc_AdministracionBancaria.cfm" method="post">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td  align="left" colspan="2" >

			<table width="100%" border="0" cellpadding="0" cellspacing="0"
			>
			<tr>
				<td align="left" colspan="10">
										
					<table border='0' cellspacing='0' cellpadding='0' width='100%'>
					<tr>
						<td class="barraboton">&nbsp;
							<a id ='CONSULTAR' href="javascript:if(document.form1.NCJM00COD.value != ''){document.form1.submit();}else{alert('Es necesario seleccionar un fondo');}" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Aceptar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
							<a id ='LIMPIAR' href="javascript:document.location = '../operacion/cjc_AdministracionBancaria.cfm';" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
							<!--- <a id = 'ACEPTAR' href="javascript:ACEPTAR('S');" onmouseover="overlib('Exportar a excel',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Exportar'; return true;" onmouseout="nd();"><span class=LeftNavOff buttonType=LeftNav>&nbsp;Exportar&nbsp;</span></a> --->
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
	
		<TABLE  BORDER="0" cellspacing="1" cellpadding="1" width="100%">
		<TR>
			<TD>Periodo</TD>
			<TD>
				<cfquery datasource="#session.Fondos.dsn#" name="rsPeriodo">
				Select distinct PERCOD
				from CJX012
				order by PERCOD
				</cfquery>
				
				<cfif not isdefined("form.PERCOD")>
					<cfset form.PERCOD = year(now())>
				</cfif>
				
				<SELECT NAME="PERCOD" size="1" style="font-size:8pt;  font-family: Courier New;">
				<cfoutput query="rsPeriodo">					
						<option value="#PERCOD#"  
						<cfif isdefined("form.PERCOD") and isdefined("rsPeriodo") 
						  and len(form.PERCOD) and len(rsPeriodo.PERCOD)
						  and form.PERCOD eq rsPeriodo.PERCOD>selected</cfif>>#PERCOD#</option>
				</cfoutput>
				</SELECT>
			</TD>
			<TD width="10%">&nbsp;</TD>
			<TD>Mes</TD>
			<TD>
				<cfif not isdefined("form.MESCOD")>
					<cfset form.MESCOD = month(now())>
				</cfif>
				
				<SELECT NAME="MESCOD" size="1" style="font-size:8pt;  font-family: Courier New;">
					<cfloop from="1" to="12" step="1" index="indmes">
						<OPTION  VALUE="<cfoutput>#indmes#</cfoutput>"
						<cfif isdefined("form.MESCOD") and len(form.MESCOD) 
					      and form.MESCOD eq indmes>selected</cfif>>
					  
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
						</OPTION>
					</cfloop>			
				</SELECT>
			</TD>
		</TR>		
		<TR>
			<TD width="15%">Fondo</TD>
			<TD width="25%">
				<cfset filfondo = false >
				<cfif not isdefined("NCJM00COD")>
					<cf_cjcConlis 	
						size		 = "20"
						tabindex     = "1"
						name 		 = "NCJM00COD"
						desc 		 = "CJM00DES"
						id			 = "CJM00COD"
						cjcConlisT 	 = "cjc_traefondo"
						sizecodigo	 = 4
						frame		 = "frm_fondos"
						filtrarfondo = "#filfondo#"
					>							
				<cfelse>				
					<cfquery name="rsQryFondo" datasource="#session.Fondos.dsn#">
						SELECT CJM00COD as NCJM00COD, CJM00COD,CJM00DES 
						FROM CJM000
						where  CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NCJM00COD#" >
					</cfquery>			
						
					<cf_cjcConlis 	
						size		 = "20"  
						tabindex     = "1"
						name 		 = "NCJM00COD"
						desc 		 = "CJM00DES" 
						id			 = "CJM00COD"						
						cjcConlisT 	 = "cjc_traefondo"
						sizecodigo	 = 4
						query        = "#rsQryFondo#"
						frame		 = "frm_fondos"
						filtrarfondo = "#filfondo#"
					>
				</cfif>		
			</TD>
			<TD width="10%">&nbsp;</TD>
			<TD width="15%">Fecha</TD>
			<TD width="25%">
				<cfif isdefined("Fechafiltro")>
					<cfset F_FINAL = #Fechafiltro#>
				<cfelse>
					<cfset F_FINAL = "">
				</cfif>
				<cf_CJCcalendario  tabindex="1" name="Fechafiltro" form="form1"  value="#F_FINAL#">	
			</TD>			
		</TR>
		<TR>
			<TD>Num. de tarjeta</TD>
			<TD>
				<INPUT 	TYPE="textbox" 
					NAME="TR01NUT" 
					ID  ="TR01NUT"
					VALUE="<cfif isdefined("TR01NUT")><cfoutput>#TR01NUT#</cfoutput></cfif>" 
					SIZE="20" 
					MAXLENGTH="20" 
					ONFOCUS="this.select(); " 
					ONKEYUP="" 
					style="visibility:"
				>		
			</TD>
			<TD width="10%">&nbsp;</TD>
			<TD>No. autorizaci&oacute;n</TD>
			<TD>
				<INPUT 	TYPE="textbox"  
					NAME="CJX12AUT" 
					ID  ="CJX12AUT"
					VALUE="<cfif isdefined("CJX12AUT")><cfoutput>#CJX12AUT#</cfoutput></cfif>" 
					SIZE= "20" 
					MAXLENGTH="20" 					
					ONFOCUS="this.select(); " 
					ONKEYUP="" 
					style="visibility:"
				>		
			</TD>
		</TR>
		</TABLE>

	</td>
</tr>
<tr><td>&nbsp;</td></tr>
</form>
<cfif isdefined("btnFiltrar")>
<tr>
	<td>

		<cfset modo="CAMBIO">
		
		<!--- Consulta todos los datos de la 12 que coinciden 
			  con los filtros y no estan conciliados --->

		<cfset filtro = "">	
		<cfset navegacion = "?modo=#modo#">
		
		<cfoutput>	
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
			<cfset filtro = filtro & " and CJM00COD = '#NCJM00COD#'">	
			<cfset navegacion = navegacion & "&CJM00COD=#NCJM00COD#">
		</cfif>
		<cfif isdefined("Fechafiltro") and len(Fechafiltro)>
			<cfset filtro = filtro & " and CJX12FEC = '#LSdateformat(Fechafiltro,"yyyymmdd")#'">	
			<cfset navegacion = navegacion & "&Fechafiltro=#Fechafiltro#">
		</cfif>
		<cfif isdefined("PERCOD") and len(PERCOD)>
			<cfset filtro = filtro & " and PERCOD = #PERCOD#">
			<cfset navegacion = navegacion & "&PERCOD=#PERCOD#">
		</cfif>
		<cfif isdefined("MESCOD") and len(MESCOD)>
			<cfset filtro = filtro & " and MESCOD = #MESCOD#">	
			<cfset navegacion = navegacion & "&MESCOD=#MESCOD#">
		</cfif>
		<cfif isdefined("TR01NUT") and len(TR01NUT)>
			<cfset filtro = filtro & " and TR01NUT = '#TR01NUT#'">
			<cfset navegacion = navegacion & "&TR01NUT=#TR01NUT#">
		</cfif>
		<cfif isdefined("CJX12AUT") and len(CJX12AUT)>
			<cfset filtro = filtro & " and CJX12AUT = '#CJX12AUT#'">
			<cfset navegacion = navegacion & "&CJX12AUT=#CJX12AUT#">
		</cfif>	  
		</cfoutput>

		<cfinvoke 
			component="sif.fondos.Componentes.pListas"
			method="pLista"
			returnvariable="pListaRet">
			<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
			<cfinvokeargument name="tabla" value="CJX012"/>
			<cfinvokeargument name="columnas" value="TS1COD,TR01NUT,CJX12AUT,convert(varchar,CJX12FEC,103) CJX12FEC,CJX12IMP,EMPNOM, PERCOD, MESCOD"/>
			<cfinvokeargument name="desplegar" value="TR01NUT,CJX12AUT,CJX12FEC,EMPNOM, CJX12IMP"/>
			<cfinvokeargument name="etiquetas" value="No. Tarjeta,Autorizaci&oacute;n,Fecha, Empleado, Monto"/>
			<cfinvokeargument name="formatos" value=",S,S,S,S,M"/>
			<cfinvokeargument name="filtro" value=" CJX12IND = 'N' #filtro#"/>
			<cfinvokeargument name="align" value="left,left,left,left,right"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="MaxRows" value="50"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="keys" value="TS1COD, TR01NUT, CJX12AUT, CJX12FEC, PERCOD, MESCOD"/>
			<cfinvokeargument name="irA" value="cjc_AdministracionBancaria.cfm?pan=1"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>			
		</cfinvoke>			
	</td>
</tr>
</cfif>
</table>
