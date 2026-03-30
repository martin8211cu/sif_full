<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

	<cfif isdefined("url.F_Hoja") and len(trim(url.F_Hoja)) gt 0>
		<cfset form.F_Hoja = #url.F_Hoja#>
	</cfif>
	<cfif isdefined("url.F_columna") and url.F_columna gt 0>
		<cfset form.F_columna = #url.F_columna#>
	</cfif>
	<cfif isdefined("url.F_fila") and url.F_fila gt 0>
		<cfset form.F_fila = #url.F_fila#>
	</cfif>
	<cfif isdefined("url.F_Rango") and len(trim(url.F_Rango)) gt 0>
		<cfset form.F_Rango = #url.F_Rango#>
	</cfif>				
	<cfif isdefined("url.F_Estado") and url.F_Estado gt 0>
		<cfset form.F_Estado = #url.F_Estado#>
	</cfif>
	<cfif isdefined("url.F_Cuentas") and url.F_Cuentas gt -1>
		<cfset form.F_Cuentas = #url.F_Cuentas#>
	</cfif>
	

	<cfquery name="rsAnexo" datasource="#Session.DSN#">
		select AnexoDes, <cf_dbfunction name="to_date00" args="AnexoFec"> as AnexoFec, AnexoUsu 
		from Anexo
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>

	<cfquery name="rsAnexoCel" datasource="#Session.DSN#">
		select 	ac.AnexoRan as name, 
				<cf_dbfunction name="to_char" args="ac.AnexoCelId"> as AnexoCelId, 
				av.AVnombre,
				ac.AnexoCon, 
				ca.CAdescripcion, 
				ac.AnexoHoja as Sheet, 
				ac.AnexoFila, 
				ac.AnexoColumna, 
				ac.AnexoFor,
				case
					when ac.GEid 		is not null then 'GE'
					when ac.GOid 		is not null then 'GO'
					when ac.Ocodigo 	is not null then 'O'
					when ac.Ecodigocel	is not null then 'E'
					else 'CAL'
				end TipoOrigenDatos,
				case
					when ac.GEid 		is not null then GEnombre
					when ac.GOid 		is not null then GOnombre
					when ac.Ocodigo 	is not null then Odescripcion
					when ac.Ecodigocel	is not null then Edescripcion
				end OrigenDatos,
				coalesce((select count(1) from AnexoCelD dc where dc.AnexoCelId = ac.AnexoCelId), 0) as ExistenCuentas
		from AnexoCel ac
			left outer join AnexoVar av
				on av.AVid = ac.AVid
			left outer join ConceptoAnexos ca
				on ca.CAcodigo = ac.AnexoCon

			left join AnexoGEmpresa ge
			  on ge.GEid = ac.GEid
			left join AnexoGOficina go
			  on go.GOid = ac.GOid
			left join Oficinas o
			  on o.Ecodigo = ac.Ecodigocel
			 and o.Ocodigo = ac.Ocodigo
			left outer join Empresas em
				on em.Ecodigo = ac.Ecodigocel
		where ac.AnexoId = <cfqueryparam cfsqltype="cf_sql_decimal" value="#url.AnexoId#">
		<cfif isdefined("form.F_Hoja") and len(trim(form.F_Hoja)) gt 0>
			and ac.AnexoHoja = '#form.F_Hoja#'
		</cfif>
		<cfif isdefined("form.F_columna") and form.F_columna gt 0>
			and ac.AnexoColumna = #form.F_columna#
		</cfif>
		<cfif isdefined("form.F_fila") and form.F_fila gt 0>
			and ac.AnexoFila = #form.F_fila#
		</cfif>
		<cfif isdefined("form.F_Rango") and len(trim(form.F_Rango)) gt 0>
			and ac.AnexoRan like '%#form.F_Rango#%'
		</cfif>				
		<cfif isdefined("form.F_Estado") and form.F_Estado gt 0>
		
			<cfif form.F_Estado eq 1>
				<!--- BD --->
				and AnexoFila = 0
				and AnexoColumna = 0
			<cfelseif form.F_Estado eq 2>
				<!--- HOJA --->
				and AnexoFila > 0
				and AnexoColumna > 0				
				and AnexoCon is null
			<cfelseif form.F_Estado eq 3>
				<!--- DEFINIDO --->
				and AnexoFila > 0
				and AnexoColumna > 0
				and AnexoCon is not null
			<cfelseif form.F_Estado eq 4>
				<!--- CON FORMULA --->
				and AnexoFor is not null
			<cfelseif form.F_Estado eq 5>
				<!--- MULTIPLES CELDAS --->
				and AnexoFila = -1
				and AnexoColumna = -1
			</cfif>
		</cfif>
		<cfif isdefined("form.F_Cuentas")>
			<cfif form.F_Cuentas eq 1>
				and exists(Select 1
							from AnexoCelD acd
							where acd.AnexoCelId = ac.AnexoCelId)			
			</cfif>
			<cfif form.F_Cuentas eq 0>
				and not exists(Select 1
							   from AnexoCelD acd
							   where acd.AnexoCelId = ac.AnexoCelId)						
			</cfif>			
		</cfif>
		Order by ac.AnexoHoja, ac.AnexoFila, ac.AnexoColumna
	</cfquery>

	<!--- <cfquery name="rsxml" datasource="#Session.DSN#">
		select AnexoDef
		from Anexoim 
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_decimal" value="#url.AnexoId#">
	</cfquery> --->

	<!--- Crear una variable que contenga el xml del Anexo 
	<cfset rsRangosExcel = QueryNew("Sheet,name,range,col,row,RefersTo")>
	<cfif Len(rsxml.AnexoDef)>

	
		<cfset xmldoc = XMLParse(rsxml.AnexoDef)>
		<cfset xmlNamedRanges = XMLSearch(xmldoc, "//ss:Workbook/ss:Names/ss:NamedRange")>
		<cfloop from="1" to="#ArrayLen(xmlNamedRanges)#" index="i">
			<cfset RangeName = xmlNamedRanges[i].XmlAttributes['ss:Name']>
			<cfset RefersTo  = xmlNamedRanges[i].XmlAttributes['ss:RefersTo']>
			<cfset SheetName = Replace(Replace(ListFirst(RefersTo,"!"),'=',''),"'",'','all')>
			<cfset Rango     = ListFirst(ListRest(RefersTo,"!"),':')>
			<cfif FindNoCase("C", rango) GTE 1>
				<cfset rangoCol = mid(rango, findnocase("C", rango) + 1, 255) >
				<cfset rangoRow = mid(rango, 2, findnocase("C", rango) - 2) >
			<cfelse>
				<cfset rangoCol = 0 >
				<cfset rangoRow = 0 >
			</cfif>
			
			<cfset temp = QueryAddRow(rsRangosExcel,1)>
			<cfset QuerySetCell(rsRangosExcel, "RefersTo",   RefersTo, i)>
			<cfset QuerySetCell(rsRangosExcel, "Sheet", SheetName, i)>
			<cfset QuerySetCell(rsRangosExcel, "name",  RangeName, i)>
			<cfset QuerySetCell(rsRangosExcel, "range", rango, i)>
			<cfset QuerySetCell(rsRangosExcel, "row",   rangoRow, i)>
			<cfset QuerySetCell(rsRangosExcel, "col",   rangoCol, i)>
		</cfloop>
	</cfif>--->
<!--- 
	<cfif rsRangosExcel.RecordCount>
		
		<cfquery name="rsRangosUnion" dbtype="query" >
			select Sheet, name
			from rsAnexoCel
			union
			select Sheet, name
			from rsRangosExcel			
		</cfquery>
					
	<cfelse>
		<cfset rsRangosUnion = rsAnexoCel>
	</cfif> --->

	<cfoutput>

	<cfparam name="PageNum_rsRangosUnion" default="1">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

	<cfif isdefined("url.PageNum_rsRangosUnion") and len(trim(url.PageNum_rsRangosUnion)) and not isdefined("form.pagina")>
		<cfset form.pagina = url.PageNum_rsRangosUnion >
	<cfelseif isdefined("url.pagina") and len(trim(url.pagina)) and not isdefined("form.pagina")>
		<cfset form.pagina = url.pagina >
	</cfif>
	
	<cfset MaxRows_rsRangosUnion = 20>
	<cfif isdefined("form.pagina") and len(trim(form.pagina))>
	<cfset PageNum_rsRangosUnion = form.pagina>
	</cfif>

	<cfset StartRow_rsRangosUnion=Min((PageNum_rsRangosUnion-1)*MaxRows_rsRangosUnion+1,Max(rsAnexoCel.RecordCount<!--- rsRangosUnion.RecordCount --->,1))>
	<cfset EndRow_rsRangosUnion=Min(StartRow_rsRangosUnion+MaxRows_rsRangosUnion-1,rsAnexoCel.RecordCount<!--- rsRangosUnion.RecordCount --->)>
	<cfset TotalPages_rsRangosUnion=Ceiling(rsAnexoCel.RecordCount<!--- rsRangosUnion.RecordCount --->/MaxRows_rsRangosUnion)>
	<cfset QueryString_rsRangosUnion=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
	<cfset tempPos=ListContainsNoCase(QueryString_rsRangosUnion,"PageNum_rsRangosUnion=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_rsRangosUnion=ListDeleteAt(QueryString_rsRangosUnion,tempPos,"&")>
	</cfif>

	</cfoutput> <br>
	
	<table width="930" border="0" cellpadding="0" cellspacing="0" align="center">

		<tr> 
			<td width="930" align="center" valign="top" nowrap>
				<table border="0" cellspacing="0" cellpadding="2" width="100%">
					<tr>
						<td colspan="9">
							<cfinclude template="FiltroAnexos.cfm">
						</td>
					</tr>
					<tr>
						<td colspan="9" align="center" bgcolor="#CCCCCC"><strong><font size="2">Rangos Definidos</font></strong></td>
					</tr>

					<tr class="tituloListas">
					  <td><strong>Hoja</strong></td> 
						<td><strong>Rango</strong></td>
						<td><strong>Fila</strong></td>												
						<td><strong>Col</strong></td>						
						<td align="left"><strong>Estado</strong></td>
						<td align="center"><strong>Cuentas</strong></td>
						<td align="left"><strong>Contenido</strong></td>
						<td align="left" colspan="2"><strong>&nbsp;Origen Datos</strong></td>
					
					</tr>
					
					<cfif isdefined("url.nav") or isdefined("form.nav")>
						<cfset Vflts = "">
					<cfelse>
	
						<cfset Vflts = "&nav=1">
						<cfif isdefined("form.F_Hoja") and len(trim(form.F_Hoja)) gt 0>
							<cfset Vflts = Vflts & "&F_Hoja=#form.F_Hoja#">
						</cfif>
						<cfif isdefined("form.F_columna") and form.F_columna gt 0>
							<cfset Vflts = Vflts & "&F_columna=#form.F_columna#">
						</cfif>		
						<cfif isdefined("form.F_fila") and form.F_fila gt 0>
							<cfset Vflts = Vflts & "&F_fila=#form.F_fila#">
						</cfif>
						<cfif isdefined("form.F_Rango") and len(trim(form.F_Rango)) gt 0>
							<cfset Vflts = Vflts & "&F_Rango=#form.F_Rango#">
						</cfif>									
						<cfif isdefined("form.F_Estado") and form.F_Estado gt 0>
							<cfset Vflts = Vflts & "&F_Estado=#form.F_Estado#">
						</cfif>
						<cfif isdefined("form.F_Cuentas") and form.F_Cuentas gt -1>
							<cfset Vflts = Vflts & "&F_Cuentas=#form.F_Cuentas#">
						</cfif>								
					
					</cfif>
					
					<cfset LvarAsterisco = false>
					<cfoutput query="rsAnexoCel" startrow="#StartRow_rsRangosUnion#" maxrows="#MaxRows_rsRangosUnion#"> 
						<!--- 
						<cfquery name="rsIDCelda" dbtype="query">
							select AnexoCelId from rsAnexoCel where name = '#rsRangosUnion.name#' 
						</cfquery>
						<cfquery name="rsXL" dbtype="query">
							Buscar la linea en el excel
							select col, row, Sheet, RefersTo from rsRangosExcel where name = '#rsRangosUnion.name#' 
						</cfquery>
						<cfquery name="BuscarLineaEnBD" dbtype="query">
							Buscar la linea en la base de datos 
							select AVnombre, AnexoCon, CAdescripcion from rsAnexoCel where name = '#rsRangosUnion.name#' 
						</cfquery> --->
						
						
						<!--- onclick="AsignarRango('#Trim(URLEncodedFormat(rsIDCelda.AnexoCelId))#','#Trim(URLEncodedFormat(rsXL.Sheet))#','#Trim(URLEncodedFormat(rsRangosUnion.name))#','<cfif Find(':',rsXL.RefersTo)>1<cfelse>0</cfif>', '#Trim(URLEncodedFormat(PageNum_rsRangosUnion))#')" --->
						<tr class="<cfif rsAnexoCel.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" 
							style="cursor:pointer;"							
							onclick="AsignarRango('#URLEncodedFormat(Trim(rsAnexoCel.AnexoCelId))#','#URLEncodedFormat(Trim(rsAnexoCel.Sheet))#','#URLEncodedFormat(Trim(rsAnexoCel.name))#','0', '#URLEncodedFormat(Trim(PageNum_rsRangosUnion))#',<cfif rsAnexoCel.AnexoFila EQ -1>false<cfelse>true</cfif>,<cfif rsAnexoCel.AnexoCon EQ "" AND rsAnexoCel.AnexoFor NEQ "">true<cfelse>false</cfif>)"
							onmouseover="this.className='<cfif rsAnexoCel.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>Sel';"
							onmouseout="this.className='<cfif rsAnexoCel.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>';">
						  <td nowrap>
						  		#rsAnexoCel.Sheet#								  
						  <!--- #HTMLEditFormat(rsXL.Sheet)# --->
						  </td> 
							<td title="<!--- #HTMLEditFormat(rsXL.RefersTo)# --->">
								#trim(rsAnexoCel.name)# 
								<!--- #HTMLEditFormat(rsRangosUnion.name)# --->
							</td>
							<td nowrap align="center"> <!---  style="<cfif Find(':', rsXL.RefersTo)>color:red;font-weight:bold;</cfif>"> --->
								<cfif rsAnexoCel.AnexoFila GT 0>#rsAnexoCel.AnexoFila#</cfif>
								<!--- <cfif rsXL.RecordCount GT 0>#rsXL.row#</cfif> --->
							</td>							
							<td nowrap align="center"><!---  style="<cfif Find(':', rsXL.RefersTo)>color:red;font-weight:bold;</cfif>"> --->
								<cfif rsAnexoCel.AnexoColumna GT 0>
									<!--- #rsAnexoCel.AnexoColumna# --->
									#fnColumnaExcel(rsAnexoCel.AnexoColumna)#
								</cfif>
								<!--- <cfif rsXL.RecordCount GT 0>#rsXL.col#</cfif> --->
							</td>							
							<td align="left" valign="middle" nowrap >
								
								<!--- <cfquery name="rsAnexoCelD" datasource="#Session.DSN#">
									select count(1) as cantidad from AnexoCelD 
									where AnexoCelId = 
									<cfif len(trim(rsIDCelda.AnexoCelid)) NEQ 0>#rsIDCelda.AnexoCelId#<cfelse>-100</cfif>
								</cfquery> --->
								
								<!--- Para sacar el estado se siguien los siguientes lineamientos:
									1. Solo existe en la hoja: fila y columna no son cero  y concepto null
									2. Solo existe en la base de datos, fila y col en cero
									3. Se encuentra definido: Tiene fila, col y concepto
								 --->								
								
								<cfif rsAnexoCel.AnexoFila EQ 0 and rsAnexoCel.AnexoColumna EQ 0>
									<!--- Solo en BD --->
									<cfset img='<img src="../../../imagenes/Recordset.gif" alt="">&nbsp;<font color="##FF0000">ERR: BD</font>'>
								<cfelseif rsAnexoCel.AnexoFila EQ -1 and rsAnexoCel.AnexoColumna EQ -1>
									<!--- Rangos de más de una Celda --->
									<cfif rsAnexoCel.AnexoCon EQ "">
										<cfset img='<img src="../../../imagenes/Base.gif" width="18" height="14" alt="">&nbsp;Celdas'>
									<cfelse>
										<cfset img='<img src="../../../imagenes/Base.gif" width="18" height="14" alt="">&nbsp;<font color="##FF0000">ERR: Celdas</font>'>
									</cfif>
								<cfelseif rsAnexoCel.AnexoFila EQ -2 and rsAnexoCel.AnexoColumna EQ -2>
									<!--- Rangos sin Refernecia --->
									<cfset img='<img src="../../../imagenes/Cferror.gif" alt="">&nbsp;<font color="##FF0000">ERR: ##REF!</font>'>
								<cfelseif rsAnexoCel.AnexoFila GT 0 and rsAnexoCel.AnexoColumna GT 0 and rsAnexoCel.AnexoCon NEQ "">
									<cfset img='<img src="../../../imagenes/options.small.png" alt="" >&nbsp;OK'>
									<cfif rsAnexoCel.AnexoFor NEQ "">
										<cfset LvarAsterisco = true>
										<cfset img=img & '<font color="##FF0000">&nbsp;(*)</font>'>
									</cfif>
								<cfelseif rsAnexoCel.AnexoFor NEQ "">
									<cfset img='<img src="../../../imagenes/DSL_D.gif" width="15" height="13" alt="">&nbsp;Fórmula'>
								<cfelse>
									<cfset img='<img src="../../../imagenes/toolbar_sub.gif" width="15" height="20" alt="">&nbsp;Hoja'>
								</cfif>
								<!--- 
								<cfif rsXL.RecordCount EQ 0>
									<cfset img='<img src="../../../imagenes/Recordset.gif" alt="">BD '>
								<cfelse>
									<cfif BuscarLineaEnBD.recordcount GT 0>
										<cfset img='<img src="../../../imagenes/options.small.png" alt="" > '>
									<cfelse>
										<cfset img='<img src="../../../imagenes/toolbar_sub.gif" width="15" height="20" alt="">Hoja '>
									</cfif>
								</cfif> --->
								#img#
							</td>
	
							<td align="center" valign="middle">
								
								
								<cfif isdefined("form.F_Cuentas") and form.F_Cuentas gt -1>

									<cfif form.F_Cuentas eq 1>
										S&iacute;			
									</cfif>
									<cfif form.F_Cuentas eq 0>
										No
									</cfif>			
								
								<cfelse>


<!--- 
										<cfquery name="rsExistenCuentas" datasource="#Session.DSN#">
										Select count(1) as haycuentas
										from AnexoCelD a, AnexoCel b
										where a.AnexoCelId = #rsAnexoCel.AnexoCelid#
										  and a.AnexoCelId = b.AnexoCelId
										</cfquery>								
										
										<cfif rsExistenCuentas.haycuentas GT 0>
											S&iacute;
										<cfelse>
											No
										</cfif>
 --->								

										<cfif rsAnexoCel.ExistenCuentas GT 0>
											S&iacute;
										<cfelse>
											No
										</cfif>

								</cfif>								

								<!--- 
								<cfif isdefined("rsAnexoCelD.cantidad")>
									<cfif rsAnexoCelD.cantidad EQ 0>No<cfelse>S&iacute;</cfif>
								</cfif> --->
							</td>
						<td align="left" valign="middle">
							<!--- 
							<cfif BuscarLineaEnBD.AnexoCon EQ 3>
								#HTMLEditFormat(BuscarLineaEnBD.AVnombre)#
							<cfelse>
								#HTMLEditFormat(BuscarLineaEnBD.CAdescripcion)#
							</cfif> --->
							
							<cfif rsAnexoCel.AnexoCon EQ 3>
								#HTMLEditFormat(rsAnexoCel.AVnombre)#
							<cfelseif rsAnexoCel.CAdescripcion NEQ "">
								#HTMLEditFormat(rsAnexoCel.CAdescripcion)#
							<cfelse>
								<font style="font:'Courier New', Courier, mono; font-size:10px; color:##0080C0;">
								#HTMLEditFormat(mid(rsAnexoCel.AnexoFor,1,50))#<cfif len(rsAnexoCel.AnexoFor) GT 50> (...)</cfif>
								</font>
							</cfif>
						</td>

						<td align="center" valign="middle">
							<strong>#rsAnexoCel.TipoOrigenDatos#</strong>
						</td>
						<td align="left" valign="middle">
							<strong>#replace(rsAnexoCel.OrigenDatos," ","&nbsp;")#</strong>
						</td>
					</tr>
						
						
					</cfoutput> 

					<tr> 
						<td colspan="7">
							<table border="0" width="50%" align="center">
								<cfoutput> 								
								<tr> 
									<td width="23%" align="center"> <cfif PageNum_rsRangosUnion GT 1><a href="#CurrentPage#?PageNum_rsRangosUnion=1#QueryString_rsRangosUnion#<cfif not isdefined("url.nav")>#Vflts#</cfif>"><img src="/cfmx/sif/imagenes/First.gif" border=0></a></cfif></td>
									<td width="31%" align="center"> <cfif PageNum_rsRangosUnion GT 1><a href="#CurrentPage#?PageNum_rsRangosUnion=#Max(DecrementValue(PageNum_rsRangosUnion),1)##QueryString_rsRangosUnion#<cfif not isdefined("url.nav")>#Vflts#</cfif>"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a></cfif></td>
									<td width="23%" align="center"> <cfif PageNum_rsRangosUnion LT TotalPages_rsRangosUnion><a href="#CurrentPage#?PageNum_rsRangosUnion=#Min(IncrementValue(PageNum_rsRangosUnion),TotalPages_rsRangosUnion)##QueryString_rsRangosUnion#<cfif not isdefined("url.nav")>#Vflts#</cfif>"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a></cfif></td>
									<td width="23%" align="center"> <cfif PageNum_rsRangosUnion LT TotalPages_rsRangosUnion><a href="#CurrentPage#?PageNum_rsRangosUnion=#TotalPages_rsRangosUnion##QueryString_rsRangosUnion#<cfif not isdefined("url.nav")>#Vflts#</cfif>"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a></cfif></td>
								</tr>
								</cfoutput>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="7">&nbsp;</td>
					</tr>					
				<cfif LvarAsterisco>
					<tr>
						<td colspan="7">
							&nbsp;<font color="#FF0000">(*) El Concepto va a sobreponerse en Cálculo a una Fórmula Excel existente en la Celda</font>
						</td>
					</tr>					
				</cfif>
				</table>
			</td>
	<!--- 
			<td width="6" align="left" valign="top" nowrap>&nbsp;</td>
			<td width="468" align="left" valign="top">
				
				
				<!--- <cfinclude template="anexo-rango-cel.cfm"> --->

				<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
					<tr><td><strong>Instrucciones:</strong></td></tr>
				
					<tr> 
						<td height="87">
							<ol>
								<li>Indique el Nombre del Rango que desea crear.</li>
								<li>Seleccione el Concepto de c&aacute;lculo para el Rango.<font color="#666699"><strong></strong></font></li>
								<li>Indique si el Mes es relativo. Cuando el Mes es relativo al 
								per&iacute;odo actual de la Contabilidad se le restan la cantidad 
								de meses indicados.</li>
								<li>Si el mes es Relativo, el Per&iacute;odo es el actual.</li>
								<li>Si no especifica una oficina para el rango se tomar&aacute; 
								la oficina que se indica en la Hoja del Anexo.</li>
								<li>Si desea que el resultado sea multiplicado por -1, marque la 
								opci&oacute;n indicada.</li>
								<li>Si desea modificar un Rango, selecci&oacute;nelo de la Lista, 
								haga el cambio que desea y oprima <font color="#333399"><strong>Modificar.</strong></font></li>
								<li>Para regresar a la Hoja del Anexo oprima <font color="#003399"><strong>Cerrar</strong></font>. 
								</li>
							</ol>
					
							<p>
								<strong>Nota:</strong><br>
								Solamente los Rangos que se encuentren en la Hoja y en la Base de 
								Datos podrán ser desplegados correctamente en la Hoja del Anexo. 
							</p>
						</td>
					</tr>
				</table>
		  </td> --->
		</tr>
	</table>
<cfoutput>
	<script language="JavaScript1.2">
	<!--
		function AsignarRango(AnexoCelId, AnexoHoja, AnexoRan, MultipleCell, pagina, esCelda, esFormula) 
		{
			if (!esCelda)
			{
				alert("El Rango no corresponde a una Celda Única en la Hoja. No puede asignársele ningún concepto.");
			}
			else if (esFormula)
			{
				if (!confirm("El Rango contiene una Fórmula en Excel.  ¿Desea sobreponerle un concepto a la Fórmula?"))
				{
					return false;
				}
			}
			location.href='anexo.cfm?AnexoId=#URLEncodedFormat(url.AnexoId)#&tab=2&AnexoCelId=' + AnexoCelId
				+ '&AnexoHoja=' + AnexoHoja
				+ '&AnexoRan=' + AnexoRan
				+ '&MultipleCell=' + MultipleCell
				+ '&Ppagina=' + pagina				
				<cfif isdefined("form.F_Hoja") and len(trim(form.F_Hoja)) gt 0>
					+ '&F_Hoja=<cfoutput>#form.F_Hoja#</cfoutput>'
				</cfif>
				<cfif isdefined("form.F_columna") and form.F_columna gt 0>
					+ '&F_columna=<cfoutput>#form.F_columna#</cfoutput>'
				</cfif>		
				<cfif isdefined("form.F_fila") and form.F_fila gt 0>
					+ '&F_fila=<cfoutput>#form.F_fila#</cfoutput>'
				</cfif>
				<cfif isdefined("form.F_Rango") and len(trim(form.F_Rango)) gt 0>
					+ '&F_Rango=<cfoutput>#form.F_Rango#</cfoutput>'
				</cfif>									
				<cfif isdefined("form.F_Estado") and form.F_Estado gt 0>
					+ '&F_Estado=<cfoutput>#form.F_Estado#</cfoutput>'
				</cfif>
				<cfif isdefined("form.F_Cuentas") and form.F_Cuentas gt -1>
					+ '&F_Cuentas=<cfoutput>#form.F_Cuentas#</cfoutput>'
				</cfif>								
				+ '&cta=1';
		}
	//-->
	</script>
</cfoutput>

<cffunction name="fnColumnaExcel" returntype="string" output="false">
	<cfargument name="Columna" type="numeric">
	
	<cfset var LvarLetraS = "">
	<cfset var LvarLetraN = 0>
	<cfset var LvarColS = "">
	<cfset var LvarColN = Columna>
	<cfloop condition="LvarColN GT 0">
		<cfset LvarLetraN = int((LvarColN-1) mod 26) + 1>
		<cfset LvarLetraS = chr(LvarLetraN + 64)>
		<cfset LvarColS = LvarLetraS & LvarColS>

		<cfset LvarColN = int((LvarColN-1) / 26)>
	</cfloop>
	<cfreturn "#LvarColS#">
</cffunction>
