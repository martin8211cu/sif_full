<cfset navegacion=''>

<cfif isdefined ('Attributes.entrada') and len(trim(Attributes.entrada)) GT 0>
	
	<cfset Lvar="and tp.CCHTestado = 'EN APROBACION CCH'">
	<cfset LvarD='Aprobar=1'>
<cfelse>
	<cfset Lvar=''>
	<cfset LvarD=''>
</cfif>

<cfif isdefined ('url.CCHcodigo') and not isdefined('form.cod')>
	<cfset form.cod=#url.CCHcodigo#>
</cfif>

<cfif isdefined ('url.numero') and not isdefined('form.num')>
	<cfset form.cod=#url.numero#>
</cfif>

<cfif isdefined ('url.Mcodigo') and not isdefined('form.McodigoOri') >
	<cfset form.McodigoOri=#url.Mcodigo#>
</cfif>

<cfif isdefined ('url.Fecha') and not isdefined('form.finicio') >
	<cfset form.finicio=#url.Fecha#>
</cfif>

<cfif isdefined ('url.Fechaf') and not isdefined('form.fhasta') >
	<cfset form.fhasta=#url.Fechaf#>
</cfif>

<cfquery name="rsUsu" datasource="#session.dsn#">
	select llave from  UsuarioReferencia where Ecodigo=#session.EcodigoSDC# and STabla='DatosEmpleado' and Usucodigo=#session.Usucodigo#
</cfquery>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select
		tp.CCHTid,
		tp.Ecodigo,
		tp.Mcodigo,
		tp.CCHTestado,
		tp.CCHTmonto,
		tp.CCHTtipo,
		tp.CCHid,
		c.CCHcodigo,
		tp.CCHcod,
		tp.Mcodigo,
		(select Miso4217 from Monedas where Mcodigo=tp.Mcodigo) as Moneda,
		tp.BMfecha
	from
	CCHTransaccionesProceso tp
	inner join CCHica c
	on c.CCHid=tp.CCHid
	and CCHTtipo in ('CIERRE','AUMENTO','DISMINUCION'<cfif isdefined ('Attributes.entrada') and len(trim(Attributes.entrada)) GT 0>,'REINTEGRO'</cfif>)
	<!---and CCHresponsable=#rsUsu.llave#--->
	where 
	tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	
	<cfif not isdefined ('form.chkRechazadas') and len(trim(Attributes.entrada)) EQ 0 and not isdefined ('form.chkConfir') and not isdefined ('url.Confir')>
		and tp.CCHTestado in ('EN PROCESO')
	</cfif>
	
	<cfif  isdefined ('form.chkRechazadas') and form.chkRechazadas eq 'on'>
		and tp.CCHTestado ='RECHAZADO'
	</cfif>
	
	<cfif  isdefined ('form.chkConfir') and form.chkConfir eq 'on' >
		and tp.CCHTestado ='POR CONFIRMAR'
		and CCHTtipo in ('CIERRE','DISMINUCION')
	</cfif>
	
	<cfif (isdefined ('form.cod') and len(trim(form.cod)) gt 0) or (isdefined('url.CCHcodigo') and url.CCHcodigo gt 0)>
		and CCHcodigo like '%#form.cod#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CCHcodigo=" & form.cod>
	</cfif>	
	
	<cfif (isdefined ('form.num') and len(trim(form.num)) gt 0) or (isdefined('url.numero') and url.numero gt 0)>
		and CCHcod=#form.num#
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "numero=" & form.num>
	</cfif>
	
	<cfif (isdefined ('form.McodigoOri') and len(trim(form.McodigoOri)) and form.McodigoOri gt 0)>
		and tp.Mcodigo=#form.McodigoOri#
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & form.McodigoOri>
	</cfif>	
	
	<cfif isdefined ('form.finicio') and len(trim(form.finicio)) gt 0 and len(trim(form.fhasta)) eq 0>
		and tp.BMfecha > = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Fecha=" & form.finicio>
	</cfif>
	
	<cfif isdefined ('form.fhasta') and len(trim(form.fhasta)) gt 0 and len(trim(form.finicio)) eq 0>
		and tp.BMfecha = < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fhasta)#">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Fechaf=" & form.fhasta>
	</cfif>
	
	<cfif isdefined ('form.finicio') and len(trim(form.finicio)) and isdefined ('form.fhasta') and len(trim(form.fhasta))>
		and tp.BMfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fhasta)#">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Fechaf=" & form.fhasta>
	</cfif>
	
	#PreserveSingleQuotes(Lvar)#
</cfquery>

<form name="form1" method="post">
	<table width="100%">
		<tr>
			<td align="right">
				<strong>Caja:</strong>
			</td>
			<td>
				<input type="text" name="cod">
			</td>
			<td align="right">
				<strong>Fechas:</strong>
			</td>
			<td nowrap="nowrap" align="left" colspan="2" >
				<table>
					<tr>
						<td>
							Desde:
						</td>
							<cfset fechainicio=Now()>
							<!---<cfif modo NEQ 'ALTA'>
							<cfset fechadesde = DateFormat(rsForm.GEAdesde,'DD/MM/YYYY') >
							</cfif>--->
						<td>
							<cf_sifcalendario form="form1" value="" name="finicio" tabindex="1">
						</td> 
						<td>
							Hasta:
						</td>
							<cfset fechahasta=Now()>
							<!---<cfif modo NEQ 'ALTA'>
							<cfset fechahasta = DateFormat(rsForm.GEAhasta,'DD/MM/YYYY') >
							</cfif>--->
						<td>
							<cf_sifcalendario form="form1" value="" name="fhasta" tabindex="1">
						</td>
					</tr>
				</table>				
			</td>
		</tr>
		
		<tr>
			<td nowrap="nowrap" align="right">
				<strong>Num.Transacci&oacute;n:</strong>
			</td>
			<td>
				<input type="text" name="num" maxlength="10"  />
			</td>
			<td nowrap="nowrap" align="right">
				<strong>Moneda:</strong>
			</td>
			<td>
				<cf_sifmonedas  FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" 
				form="form1" Mcodigo="McodigoOri" tabindex="1" todas="S">
			</td>
	
			<td  align="right">
				<input type="submit" value="Filtrar" name="filtrar">
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap" colspan="6">
				<cfif not isdefined ('Attributes.entrada') or len(trim(Attributes.entrada)) eq 0>
				<input type="checkbox" name="chkRechazadas" onclick="irA()" <cfif isdefined ('form.chkRechazadas') and form.chkRechazadas eq 'on'>checked="checked"</cfif> /><strong>Lista de Transacciones Rechazadas</strong>
				<input type="checkbox" name="chkConfir" onclick="irA2()"  <cfif isdefined ('form.chkConfir') and form.chkConfir eq 'on' or isdefined ('url.Confir')>checked="checked"</cfif>/><strong>Confirmaci&oacute;n de Dep&oacute;sitos</strong>
				</cfif>
			</td>
		</tr>
		</form>
		<tr>
			<td colspan="7">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsSQL#"
					columnas="CCHTid,CCHcodigo,Mcodigo,CCHTestado,CCHTmonto,CCHTtipo,CCHid,BMfecha,CCHcod,Moneda"
					desplegar="CCHcod,CCHcodigo,CCHTtipo,CCHTestado,CCHTmonto,Moneda,BMfecha"
					etiquetas="Num.Transacci&oacute;n,Caja,Transacci&oacute;n,Estado,Monto,Moneda,Fecha"
					formatos="S,S,S,S,M,S,D"
					align="left,left,left,left,right,center,left"
					ira="CCHtransac.cfm?#LvarD#"
					incluyeForm="yes"
					formName="formX"
					form_method="post"
					showEmptyListMsg="yes"
					keys="CCHTid,CCHid"	
					MaxRows="15"
					checkboxes="N"
					botones="Nuevo"
					navegacion="#navegacion#"
				/>		
				
				
			</td>
		</tr>
	</table>
<script language="javascript" type="text/javascript">
	function irA(){
		document.form1.chkConfir.checked=false
		document.form1.submit();
	}
	function irA2(){
	
		document.form1.chkRechazadas.checked=false
		document.form1.submit();
	}
</script>

