<cfset navegacion=''>
<cf_dbfunction name="OP_concat"	args=""  returnvariable="_Cat" >
<cfparam name="form.chkTodas" default="0">
<cfif isdefined ('CBid')>
	<cfset form.CBid=ListFirst(#CBid#,',')>
</cfif>

<cfif isdefined ('url.num') and not isdefined('form.num')>
	<cfset form.num=#url.num#>
</cfif>

<table width="100%" border="0">
	
	<form name="form1" method="post">
		<tr>
			<td align="right">
				<strong>Trabajar con Tesorería:</strong>
			</td>
			<td>	
				<cf_cboTESid onchange="this.form.submit();" tabindex="1">
			</td>
		</tr>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				select
					a.CBid,a.TESRdescripcion,
					case a.TESRestado 
						when 0  then 'En Preparacion'
						when 1  then 'En Registro Transferencias'
						when 2  then 'Transferencia Aplicada'
						when 11  then 'En Emisión' 
						when 12  then 'Reintegro Emitido' 
						when 13  then 'Rechazada'
						end as estado
					,TESRmonto,TESRnumero,
					(select ep.Edescripcion #_Cat# ' - ' #_Cat# mp.Miso4217 #_Cat# ' - ' #_Cat# bp.Bdescripcion  #_Cat# ' - ' #_Cat# cp.CBcodigo
						 from TEScuentasBancos t
							inner join CuentasBancos cp
								inner join Empresas ep
									inner join Monedas mep
										 on mep.Mcodigo = ep.Mcodigo
									 on ep.Ecodigo = cp.Ecodigo
								inner join Bancos bp
									 on bp.Bid = cp.Bid
								inner join Monedas mp
									 on mp.Ecodigo = cp.Ecodigo
									and mp.Mcodigo = cp.Mcodigo
								 on cp.CBid = t.CBid
						where a.CBid=t.CBid
                        and cp.CBesTCE = 0
						and t.TESCBreintegrable=1
					) as CuentaBancaria		
				from
				TESreintegro a
				where a.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				<cfif form.chkTodas EQ "0">
				and TESRestado =0
				</cfif>
				<cfif (isdefined ('form.num') and len(trim(form.num)) gt 0) or (isdefined('url.numero') and url.numero gt 0)>
					and TESRnumero=#form.num#
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "numero=" & form.num>
				</cfif>
				
				<cfif (isdefined ('form.CBid') and len(trim(form.CBid)) gt 0) or (isdefined('url.CBid') and url.CBid gt 0)>
					and a.CBid=#form.CBid#
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CBid=" & form.CBid>
				</cfif>
				
			</cfquery>

		<tr>
			<td align="right">
				<strong>Cuenta Bancaria:</strong>
			</td>
			<td>
				<cf_cboTESCBid name="CBid" value="" reintegro="yes" Ccompuesto="yes" Dcompuesto="yes" none="yes" tabindex="1">
			</td>
		</tr>
		
		<tr>
			<td nowrap="nowrap" align="right">
				<strong>Num.Transacci&oacute;n:</strong>
			</td>
			<td>
				<input type="text" name="num" maxlength="10"  />
			</td>
			<td  align="right" colspan="0">
				<input type="submit" value="Filtrar" name="filtrar">
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap" colspan="3" align="left">
				<input type="checkbox" name="chkTodas" value="1" <cfif form.chkTodas EQ 1>checked</cfif> onclick="form1.submit();">
				<strong>Trabajar con todas los Reintegros</strong>
			</td>
		</tr>
	</form>		
		<tr>
			<td colspan="7">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#rsSQL#"
					columnas="TESRnumero,CuentaBancaria,estado,TESRmonto,CBid"
					desplegar="TESRnumero,CuentaBancaria,estado,TESRmonto"
					etiquetas="Num.Transacci&oacute;n,Cuenta Bancaria,Estado,Monto"
					formatos="S,S,S,M"
					align="left,left,left,right"
					ira="TESReintegroCB.cfm?"
					incluyeForm="yes"
					formName="formX"
					form_method="post"
					showEmptyListMsg="yes"
					keys="CBid"	
					MaxRows="15"
					checkboxes="N"
					botones="Nuevo"
					navegacion="#navegacion#"
				/>						
			</td>
		</tr>
	</table>

<script language="javascript" type="text/javascript">
</script>

