<cfquery name="rsFantig" datasource="#session.dsn#">
	select EVfantig from EVacacionesEmpleado where DEid=#form.DEid# 
</cfquery>

<cfif rsFantig.recordcount gt 0 and len(trim(rsFantig.EVfantig)) gt 0>
<cfif isdefined('url.DAid') and not isdefined('form.DAid')>
	<cfset form.DAid=#url.DAid#>
</cfif>
<!---Encabezdo de la antigüedad--->
<cfset Lvar_EAid = ''>
<cfset filtro='EAid in (-1)'>
<cfquery name="rsEn" datasource="#session.dsn#">
	select EAid,coalesce(EAtotal,0) as EAtotal from EAnualidad where 
	DEid=#form.DEid#
	and Ecodigo=#session.Ecodigo#
</cfquery>

<cfif rsEn.REcordCount GT 0 and len(trim(rsEn.EAid)) gt 0><cfset Lvar_EAid = ValueList(rsEn.EAid)><cfset filtro='EAid in (#Lvar_EAid#)'></cfif>

<cfif rsEn.recordcount gt 0>
	<!---Detalles de la antigüedad--->
	<cfquery name="rsDet" datasource="#session.dsn#">
		select DAid, DAfdesde,DAfhasta,DAanos
		from DAnualidad
		where EAid=#rsEn.EAid#
	</cfquery>
</cfif>

<cfif isdefined('form.DAid') and len(trim(form.DAid)) gt 0>
	<cfquery name="rsform" datasource="#session.dsn#">
		select DAid, DAfdesde,DAfhasta,DAanos,DAtipo,DAdias,DAtipoConcepto,DAdescripcion
		from DAnualidad
		where DAid=#form.DAid#
	</cfquery>
</cfif>


<cfif isdefined ('rsform') and rsform.recordcount gt 0>
	<cfset modoA='Cambio'>
<cfelse>
	<cfset modoA='Alta'>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	  <tr>
		<td colspan="2">
			<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
	  </tr>
	  <tr>
	  	<td valign="top" width="50%" align="left">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select DAid, DAfdesde,DAfhasta,DAanos, case 
														when DAtipoConcepto= 0	then 'Sector Público'
														when DAtipoConcepto=1 then 'Universidad Estatal'
														when DAtipoConcepto=3 then 'Médicos'
														when DAtipoConcepto=2 then 'ITCR'														
														end as DAtipoConcepto,
														case when DAanos is null then DAdias
														when DAdias is null then DAanos
														end as cant,
														case when DAanos is null then 'Días'
														when DAdias is null then 'Años'
														end as tipo,<cf_dbfunction name="string_part"   args="DAdescripcion,1,25"> as DAdescripcion
					from DAnualidad
					where #filtro#
					group by DAtipoConcepto,DAid, DAfdesde,DAfhasta,DAanos,DAdias,DAdescripcion
				</cfquery>
				<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsSQL#"/>
				<cfinvokeargument name="keycorte" value="tipo"/>
				<cfinvokeargument name="Cortes" value="DAtipoConcepto"/>
				<cfinvokeargument name="desplegar" value="DAdescripcion,DAfdesde,DAfhasta,cant,tipo"/>
				<cfinvokeargument name="etiquetas" value="Descripcion,Fecha desde, Fecha hasta,Cantidad, "/>
				<cfinvokeargument name="formatos" value="S,D,D,S,S"/>
				<cfinvokeargument name="align" value="left,left,left,center,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="incluyeForm" value="true">
				<cfinvokeargument name="formName" value="form2">
				<cfinvokeargument name="irA" value="expediente-cons.cfm?DEid=#form.DEid#&o=11"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>
		</td>
		
				<td valign="top" width="50%" align="right">
					<table border="0" width="100%">
					<form name="form1" action="SQLAnualidades.cfm" method="post">
					<cfoutput>
					<cfif isdefined('form.DEid') and len(trim(form.DEid)) gt 0>
						<input type="hidden" name="DEid" value="#form.DEid#" />
					</cfif>
					<cfif isdefined('form.DAid') and len(trim(form.DAid)) gt 0>
						<input type="hidden" name="DAid" value="#form.DAid#" />
					</cfif>
					<cfif isdefined('rsFantig.EVfantig') and len(trim(rsFantig.EVfantig)) gt 0>
						<input type="hidden" name="EVfantig" value="#rsFantig.EVfantig#" />
					</cfif>
						<tr>
							<td colspan="2">
								<cfset fechaAntig=DateFormat(#rsFantig.EVfantig#,'DD/MM/YYYY')>
								<strong>Fecha de antig&uuml;edad:</strong>&nbsp;#fechaAntig#
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;
							
							</td>
						</tr>
						<tr>
							<td>
								<strong>Fecha desde:</strong>
							</td>
							<td>
								<cfif modoA eq 'Alta'>
									<cfset fechadesde=DateFormat(Now(),'DD/MM/YYYY')>
								<cfelse>
									<cfset fechadesde=DateFormat(#rsform.DAfdesde#,'DD/MM/YYYY')>
								</cfif>
								<cf_sifcalendario form="form1" value="#fechadesde#" name="Fdesde" tabindex="1">
							</td>
						</tr>
						<tr>
							<td>
								<strong>Fecha hasta:</strong>
							</td>
							<td>
								<cfif modoA eq 'Alta'>
									<cfset fechahasta=DateFormat(Now(),'DD/MM/YYYY')>
								<cfelse>
									<cfset fechahasta=DateFormat(#rsform.DAfhasta#,'DD/MM/YYYY')>
								</cfif>
								<cf_sifcalendario form="form1" value="#fechahasta#" name="Fhasta" tabindex="1">
							</td>
						</tr>
						<tr>
							<td>
								<strong>Concepto:</strong>
							</td>
							<td>
							<!---	<cfset Lvar_Concepto = ''>
								<cfquery name="rsConcepto" datasource="#session.DSN#">
									select DAtipoConcepto from EAnualidad 
									where DEid=#form.DEid#
									and DAtipoConcepto is not null
									group by DAtipoConcepto
								</cfquery>
								<cfif rsConcepto.REcordCount GT 0><cfset Lvar_Concepto = ValueList(rsConcepto.DAtipoConcepto)></cfif>
								
								<cfset Conceptos = QueryNew("IDConcepto,Concepto")>
								<cfset newRow = QueryAddRow(Conceptos, 4)>
								<cfset querySetCell(Conceptos,"IDConcepto",'0',1)>
								<cfset querySetCell(Conceptos,"Concepto",'Sector Público',1)>
								<cfset querySetCell(Conceptos,"IDConcepto",'1',2)>
								<cfset querySetCell(Conceptos,"Concepto",'Universidad Estatal',2)>
								<cfset querySetCell(Conceptos,"IDConcepto",'2',3)>
								<cfset querySetCell(Conceptos,"Concepto",'ITCR',3)>
								<cfset querySetCell(Conceptos,"IDConcepto",'3',4)>
								<cfset querySetCell(Conceptos,"Concepto",'Médicos',4)>
								
								<cfquery name="rsConceptos" dbtype="query">
									select *
									from Conceptos
									<cfif isdefined ('Lvar_Concepto') and len(trim(Lvar_Concepto)) gt 0 and modoA eq 'Alta'>
										where IDConcepto not in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#Lvar_Concepto#">)
									</cfif>
								</cfquery>
								<select name="concepto">
									<cfloop query="rsConceptos">
										<option value="#rsConceptos.IDConcepto#" <cfif isdefined('rsForm') and rsForm.DAtipoConcepto EQ rsConceptos.IDConcepto>selected</cfif>>#rsConceptos.Concepto#</option>
									</cfloop>
								</select>--->
								
								<select name="concepto" id="concepto">
									<option value="0" <cfif modoA eq 'Cambio' and rsform.DAtipoConcepto eq 0>selected="selected"</cfif> >Sector Público</option>
									<option value="1" <cfif modoA eq 'Cambio' and rsform.DAtipoConcepto eq 1>selected="selected"</cfif> >Universidad Estatal</option>
									<option value="2" <cfif modoA eq 'Cambio' and rsform.DAtipoConcepto eq 2>selected="selected"</cfif> >ITCR</option>
									<option value="3" <cfif modoA eq 'Cambio' and rsform.DAtipoConcepto eq 3>selected="selected"</cfif> >Médicos</option>
								</select>
							</td>					
						</tr>
						<tr>
							<td>
								<strong>Cantidad:</strong>
							</td>
							<td>
								<cfif modoA eq 'Alta'>
									<cfset valor_monto=0>
								<cfelseif len(trim(rsform.DAanos)) gt 0>
									<cfset valor_monto=#rsform.DAanos#>
								<cfelse>
									<cfset valor_monto=#rsform.DAdias#>
								</cfif>
								<cf_inputNumber name="Monto" value="#valor_monto#" size="5" enteros="13">
								<cfif isdefined ('rsform') and len(trim(rsform.DAanos)) gt 0>
								<strong>años</strong>
								<cfelseif isdefined ('rsform') and len(trim(rsform.DAdias)) gt 0>
								<strong>días</strong>
								<cfelse>
								<strong>años</strong>
								</cfif>
								
							</td>
						</tr>
						<tr>
							<td><strong>Descripción:</strong></td>
							<cfif modoA eq 'Alta'>
								<cfset LvarDescr=''>
							<cfelse>
								<cfset LvarDescr=#rsform.DAdescripcion#>
							</cfif>
							<td><input type="text" name="DAdescr" maxlength="80" size="60" value="#LvarDescr#"/></td>
						</tr>
						<tr>
							<td colspan="2" nowrap="nowrap">
								<cfif isdefined ('rsform') and len(trim(rsform.DAdias)) gt 0>
									<font color="##990000">No se puede modificar el registro porque fue generado a partir de una nómina</font>
								<cfelse>
									<cfif modoA eq 'Alta'>
										<cf_botones modo="alta">
									<cfelse>
										<cf_botones modo="cambio">
									</cfif>
								</cfif>
							</td>
						</tr>
						</cfoutput>
						</form>
					</table>
				</td>
	  </tr>
</table>
<cfelse>
	<table>
		<tr>
			<td>
				<strong>El empleado no tiene una fecha de antig&uuml;edad registrada en el sistema</strong>
			</td>
		</tr>
	</table>
</cfif>
<script language="javascript">

</script>

