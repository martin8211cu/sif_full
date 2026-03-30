<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Caja" default = "Caja" returnvariable="LB_Caja" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fechas" default = "Fechas" returnvariable="LB_Fechas" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Desde" default = "Desde" returnvariable="LB_Desde" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Hasta" default = "Hasta" returnvariable="LB_Hasta" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumTransaccion" default = "N&uacute;m Transacci&oacute;n" returnvariable="LB_NumTransaccion" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Moneda" default = "Moneda" returnvariable="LB_Moneda" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" default = "Filtrar" returnvariable="BTN_Filtrar" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ListaTransaccionesRechazadas" default = "Lista de Transacciones Rechazadas" returnvariable="LB_ListaTransaccionesRechazadas" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ConfirmacionDepositos" default = "Confirmaci&oacute;n de Dep&oacute;sitos" returnvariable="LB_ConfirmacionDepositos" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Transaccion" default = "Transacci&oacute;n" returnvariable="LB_Transaccion" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Estado" default = "Estado" returnvariable="LB_Estado" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Reintegro" default = "REINTEGRO" returnvariable="LB_Reintegro" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Aumento" default = "AUMENTO" returnvariable="LB_Aumento" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Disminucion" default = "DISMINUCION" returnvariable="LB_Disminucion" xmlfile = "CCHtransac_lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cierre" default = "CIERRE" returnvariable="LB_Cierre" xmlfile = "CCHtransac_lista.xml">
        
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
				<strong><cfoutput>#LB_Caja#</cfoutput>:</strong>
			</td>
			<td>
				<input type="text" name="cod">
			</td>
			<td align="right">
				<strong><cfoutput>#LB_Fechas#</cfoutput>:</strong>
			</td>
			<td nowrap="nowrap" align="left" colspan="2" >
				<table>
					<tr>
						<td>
							<cfoutput>#LB_Desde#</cfoutput>:
						</td>
							<cfset fechainicio=Now()>
							<!---<cfif modo NEQ 'ALTA'>
							<cfset fechadesde = DateFormat(rsForm.GEAdesde,'DD/MM/YYYY') >
							</cfif>--->
						<td>
							<cf_sifcalendario form="form1" value="" name="finicio" tabindex="1">
						</td> 
						<td>
							<cfoutput>#LB_Hasta#</cfoutput>:
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
				<strong><cfoutput>#LB_NumTransaccion#</cfoutput>:</strong>
			</td>
			<td>
				<input type="text" name="num" maxlength="10"  />
			</td>
			<td nowrap="nowrap" align="right">
				<strong><cfoutput>#LB_Moneda#</cfoutput>:</strong>
			</td>
			<td>
				<cf_sifmonedas  FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" 
				form="form1" Mcodigo="McodigoOri" tabindex="1" todas="S">
			</td>
	
			<td  align="right">
				<input type="submit" value="<cfoutput>#BTN_Filtrar#</cfoutput>" name="filtrar">
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap" colspan="6">
				<cfif not isdefined ('Attributes.entrada') or len(trim(Attributes.entrada)) eq 0>
				<input type="checkbox" name="chkRechazadas" onclick="irA()" <cfif isdefined ('form.chkRechazadas') and form.chkRechazadas eq 'on'>checked="checked"</cfif> /><strong><cfoutput>#LB_ListaTransaccionesRechazadas#</cfoutput></strong>
				<input type="checkbox" name="chkConfir" onclick="irA2()"  <cfif isdefined ('form.chkConfir') and form.chkConfir eq 'on' or isdefined ('url.Confir')>checked="checked"</cfif>/><strong><cfoutput>#LB_ConfirmacionDepositos#</cfoutput></strong>
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
					etiquetas="#LB_NumTransaccion#,#LB_Caja#,#LB_Transaccion#,#LB_Estado#,#LB_Monto#,#LB_Moneda#,#LB_Fecha#"
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

