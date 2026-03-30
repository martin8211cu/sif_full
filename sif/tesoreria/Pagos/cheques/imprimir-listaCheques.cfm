<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 16 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Consulta de cheques
			Reimpresion cheques 
			Retencion cheques
			Entrega cheques
	
	Modificado por: Ana Villavicencio
	Fecha de modificación: 04 de julio del 2005
	Motivo:	En los datos de la lista se agregó el banco al q pertenece el cheque
----------->
<cfset navegacion = "">
<cf_navegacion name="TESCFDnumFormulario_F">
<cf_navegacion name="TESOPnumero_F"			session>
<cf_navegacion name="TESCFDestado_F"		session>
<cf_navegacion name="TESOPbeneficiarioId_F" session>
<cf_navegacion name="TESOPbeneficiario_F"	session>
<cf_navegacion name="EcodigoPago_F"			session>
<cf_navegacion name="Miso4217Pago_F"		session>
<cf_navegacion name="CBidPago_F"			session>
<cf_navegacion name="TESOPfechaEmision_F"	session>
<cf_navegacion name="TESOPfechaPago_F"		session>
<cf_navegacion name="TESOPtotalPago_F"		session>
<cf_navegacion name="OrderBy_F"				session default="C">
<cf_navegacion name="TESCFLUid"				session>

<!---1.Verificacion de la tesoreria, cargando la variable--->

<cfquery name="rsTES" datasource="#session.dsn#">
	Select e.TESid, t.EcodigoAdm
	  from TESempresas e
	  	inner join Tesoreria t
			on t.TESid = e.TESid
	 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif rsTES.recordCount EQ 0>
	<cfset Request.Error.Backs = 1>
	<cf_errorCode	code = "50798" msg = "ESTA EMPRESA NO HA SIDO INCLUIDA EN NINGUNA TESORERÍA">
</cfif>
<cfset session.Tesoreria.TESid = rsTES.TESid>
<cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>

<!---►►Valor del Combo del Filtro para Custodiado por◄◄--->
<cfquery name="rsLugares" datasource="#session.DSN#">
	select TESid, TESCFLUid, TESCFLUdescripcion
	from TESCFlugares
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
</cfquery>

<!---►►Valor del Combo del Filtro para Razón◄◄--->
<cfquery name="rsEstados" datasource="#session.DSN#">
	select TESid, TESCFEid, TESCFEdescripcion, BMUsucodigo, ts_rversion, TESCFEimpreso, TESCFEentregado, TESCFEanulado
	from TESCFestados
	where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		and TESCFEimpreso = 0 
		and TESCFEentregado = 0 
		and TESCFEanulado = 0
</cfquery>


	
            	<cfinclude template="../../../Utiles/sifConcat.cfm">
				<cfquery datasource="#session.dsn#" name="lista" >
					select cf.TESid,cf.CBid,cf.TESMPcodigo,cf.TESOPid, 
							cf.TESCFDnumFormulario, 
						   	op.TESOPnumero, 
							op.TESOPfechaPago, cf.TESCFDfechaGeneracion, cf.TESCFDfechaEmision, op.TESOPfechaEmision, 
							op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario, op.TESOPbeneficiarioId, 
							op.TESOPtotalPago, Miso4217 as Moneda,
						     
   							cb.CBcodigo, b.Bdescripcion,
							'CUENTA PAGO: ' #_Cat# cb.CBcodigo #_Cat# ' - ' #_Cat# b.Bdescripcion as Cuenta,
						<cfif isdefined('reimpresion')>
						   1 as btnCrear,
						</cfif>
						   case TESCFDestado
								when 0 then 'En preparacion'
								when 1 then 'Impreso'
								when 2 then 'Entregado'
								when 3 then 
									case when TESCFLidReimpresion is null 
										then 'Anulado'
										else 'Anul.Reimpr.'
									end
							end as Estado
					from TEScontrolFormulariosD cf 
	
					inner join CuentasBancos cb 
						inner join Monedas m 
						  on m.Mcodigo = cb.Mcodigo and 
							 m.Ecodigo = cb.Ecodigo 
						inner join Bancos b 
						  on b.Ecodigo	= cb.Ecodigo and 
							 b.Bid 		= cb.Bid 
						inner join Empresas e 
						  on e.Ecodigo 	= cb.Ecodigo
					  on cb.CBid = cf.CBid
					inner join TESmedioPago mp
					  on mp.TESid 		= cf.TESid and
						 mp.CBid 		= cf.CBid and 
						 mp.TESMPcodigo = cf.TESMPcodigo

					left outer join TESordenPago op 
					  on cf.TESOPid = op.TESOPid 
					 
				<!--- POR USUARIO QUE TIENE LA ULTIMA CUSTODIA --->
					<cfif isdefined('custodia')>
					inner join TEScontrolFormulariosB cfb
						 on cfb.TESid				= cf.TESid 
						and cfb.CBid				= cf.CBid
						and cfb.TESMPcodigo			= cf.TESMPcodigo
						and cfb.TESCFDnumFormulario	= cf.TESCFDnumFormulario
						and cfb.TESCFBultimo		= 1
						and cfb.UsucodigoCustodio	= #session.Usucodigo#
					</cfif>
						
					where cf.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
				<!--- TIPO DE CHEQUE O ESTADOS --->
					  and TESCFDestado <> 0
                      and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		

				<!--- REIMPRESION O FILTRO POR FECHA --->
					<cfif isdefined('reimpresion')>
						and <cf_dbfunction name="Date_Format" args="TESCFDfechaEmision,YYYYMMDD"> = '#DateFormat(Now(),'YYYYMMDD')#'
					<cfelseif isdefined('form.TESCFDfechaEmision_F') and len(trim(form.TESCFDfechaEmision_F))>
						and <cf_dbfunction name="Date_Format" args="TESCFDfechaEmision,YYYYMMDD"> = '#DateFormat(LSParseDateTime(form.TESCFDfechaEmision_F),'YYYYMMDD')#'
					</cfif>

					<cfif isdefined('form.TESCFDnumFormulario_F') and len(trim(form.TESCFDnumFormulario_F))>
						and cf.TESCFDnumFormulario=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario_F#">
					</cfif>
					<cfif isdefined('form.TESOPnumero_F') and len(trim(form.TESOPnumero_F))>
						and op.TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPnumero_F#">
					</cfif>				
					<cfif isdefined('form.TESOPbeneficiarioId_F') and len(trim(form.TESOPbeneficiarioId_F))>
						and upper(TESOPbeneficiarioId) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.TESOPbeneficiarioId_F))#%">
					</cfif>	
					<cfif isdefined('form.TESOPbeneficiario_F') and len(trim(form.TESOPbeneficiario_F))>
						and upper(TESOPbeneficiario) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.TESOPbeneficiario_F))#%">
					</cfif>	
					<cfif isdefined('form.TESCFDestado_F') and len(trim(form.TESCFDestado_F))>
						and TESCFDestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDestado_F#">
					</cfif>	
					<cfif isdefined('form.TESOPtotalPago_F') and len(trim(form.TESOPtotalPago_F)) AND form.TESOPtotalPago_F NEQ "0.00">
						and TESOPtotalPago = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TESOPtotalPago_F,",","","ALL")#">
					</cfif>	
					<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
						and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
					<cfelseif isdefined('entrega')>
						and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					</cfif>

					<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
						and cf.CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
					<cfelse>
						<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
							and cb.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
						</cfif>						
						<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
							and m.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
						</cfif>							
					</cfif>
					<cfif isdefined("GvarAnulacionEspecial")>
							and (
								select count(1)
								  from TESdetallePago
								 where TESOPid = op.TESOPid
								   and TESDPtipoDocumento NOT IN (0,5,1)
								) = 0
					</cfif>
                    <!---►►Filtro de Custodiado por◄◄--->
                    <cfif isdefined('form.TESCFLUid') and LEN(TRIM(form.TESCFLUid))>
                    		and (select count(1)
                            		from TEScontrolFormulariosB bitacC
                                    where bitacC.TESid					= cf.TESid 
                                      and bitacC.CBid					= cf.CBid
                                      and bitacC.TESMPcodigo			= cf.TESMPcodigo
                                      and bitacC.TESCFDnumFormulario	= cf.TESCFDnumFormulario
                                      and bitacC.TESCFBultimo			= 1
                                      and bitacC.TESCFLUid 			    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLUid#">) > 0
					</cfif>
                    <!---►►Filtro de Razon◄◄--->
                     <cfif isdefined('form.TESCFEid') and LEN(TRIM(form.TESCFEid))>
                    		and (select count(1)
                            		from TEScontrolFormulariosB bitacR
                                    where bitacR.TESid					= cf.TESid 
                                      and bitacR.CBid					= cf.CBid
                                      and bitacR.TESMPcodigo			= cf.TESMPcodigo
                                      and bitacR.TESCFDnumFormulario	= cf.TESCFDnumFormulario
                                      and bitacR.TESCFBultimo			= 1
                                      and bitacR.TESCFEid 			    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFEid#">) > 0
					</cfif>
					
					order by 
					<cfif form.OrderBy_F eq "C">
						Bdescripcion,CBcodigo, cf.TESCFDnumFormulario
					<cfelseif form.OrderBy_F eq "E">
						TESCFDfechaEmision
					<cfelseif form.OrderBy_F eq "P">
						op.TESOPfechaPago
					<cfelseif form.OrderBy_F eq "B">
						TESOPbeneficiario
					</cfif>
				</cfquery>
				
<cf_htmlReportsHeaders title="Consulta de Cheques" filename="Consulta_de_Cheques.xls" irA="consultaCheques.cfm" download="yes" preview="no" method="get">
    <cfflush interval="32">
	<cfoutput>
	<style type="text/css">
		table td
		{ call-spacing:0px}
		table td
		{ padding:0px 3px;}
		table th
		{ padding:3px;}
		table .tcuenta
		{background:##e6e6e6;}
		table .par
		{background:##f2f2f2;}
		table .non
		{background:##fafafa;}
	</style>
   	<table border="0" cellpadding="0" cellspacing="0" style="width:100%; font-size:12px">
    	 <tr>
            <td colspan="9" align="center" bgcolor="##E3EDEF" style="color:##6188A5; font-size:24px"><br/><strong>#session.enombre#</strong></td>
        </tr>
        <tr>
        	<td colspan="9" align="center" bgcolor="##E3EDEF" style="width:96%;"><strong>Consulta de Cheques</strong></td>            
        </tr>
		<tr><td bgcolor="##E3EDEF" align="center" colspan="9" >#dateformat(now(),'dd/mm/yyyy')#</td></tr>
		<tr>
        	<td colspan="9" align="center" bgcolor="##E3EDEF" >&nbsp;</td>
            
        </tr>
		<tr bgcolor="##D3D3D3">
			<th>Cheque</th>
			<th>Estado</th>
			<th>Num. Orden</th>
			<th>Fecha Pago</th>
			<th>Fecha Emisi&oacute;n</th>
			<th>Id. Beneficiario</th>
			<th>Beneficiario</th>
			<th>Moneda Pago</th>
			<th align="right">Monto Pago</th>
		</tr>
		<cfset cuentAnt="anterior">
		<cfset parnon=1>
		<cfloop query="lista">
			<cfif cuentAnt NEQ lista.Cuenta>		
				<tr><td colspan="9">&nbsp;</td></tr>
				<tr class="tcuenta"><td colspan="9"><b>#lista.Cuenta#</b></td></tr>
				<cfset cuentAnt=lista.Cuenta>
			</cfif>
			<tr class="<cfif parnon EQ 1><cfset parnon=0>non<cfelse><cfset parnon=1>par</cfif>">				
				<td>#lista.TESCFDnumFormulario#</td>
				<td>#lista.Estado#</td>
				<td>#lista.TESOPnumero#</td>
				<td>#LSDateFormat(lista.TESOPfechaPago ,'dd/mm/yyyy')#</td>
				<td>#LSDateFormat(lista.TESCFDfechaEmision ,'dd/mm/yyyy')#</td>
				<td>#lista.TESOPbeneficiarioId#</td>
				<td>#lista.TESOPbeneficiario#</td>
				<td>#lista.Moneda#</td>
				<td align="right">#lista.TESOPtotalPago#</td>
			</tr>			
		</cfloop>
	</table>
	</cfoutput>