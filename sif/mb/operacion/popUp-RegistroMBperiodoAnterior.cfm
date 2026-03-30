<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0><!---  varTCE  indica si es un reporte para TCE--->
	<cfset _Pagina = 'TCEMovimientos.cfm'>
	<cfset _PaginaLista = 'TCEListaMovimientos.cfm'>
	<cfset _PaginaSQL = 'TCESQLMovimientos.cfm'>
<cfelse>
	<cfset _Pagina = 'popUp-RegistroMBperiodoAnterior.cfm'>
	<cfset _PaginaLista = 'listaMovimientos.cfm'>
	<cfset _PaginaSQL = 'popUp-RegistroMBperiodoAnterior-SQL.cfm'>
</cfif>


<cfif isdefined("url.pagenum_lista")	and not isdefined("form.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("url.EMusuario") and not isdefined("form.EMusuario")>
	<cfset form.EMusuario = url.EMusuario>	 
</cfif>

<cfif isdefined("url.filtro_EMdocumento")	and not isdefined("form.filtro_EMdocumento")>
	<cfset form.filtro_EMdocumento = url.filtro_EMdocumento >
</cfif>

<cfif isdefined("url.filtro_CBid")	and not isdefined("form.filtro_CBid")>
	<cfset form.filtro_CBid = url.filtro_CBid >
</cfif>

<cfif isdefined("url.filtro_BTid")	and not isdefined("form.filtro_BTid")>
	<cfset form.filtro_BTid = url.filtro_BTid >
</cfif>

<cfif isdefined("url.filtro_EMdescripcion")	and not isdefined("form.filtro_EMdescripcion")>
	<cfset form.filtro_EMdescripcion = url.filtro_EMdescripcion >
</cfif>

<cfif isdefined("url.filtro_EMfecha")	and not isdefined("form.filtro_EMfecha")>
	<cfset form.filtro_EMfecha = url.filtro_EMfecha >
</cfif>

<cfif isdefined("url.filtro_usuario")	and not isdefined("form.filtro_usuario")>
	<cfset form.filtro_usuario = url.filtro_usuario >
</cfif>

<cfif isdefined("url.filtro_DMdescripcion") and not isdefined("form.filtro_DMdescripcion") >
	<cfset form.filtro_DMdescripcion = url.filtro_DMdescripcion >
</cfif>	

<cfif isdefined("url.filtro_Cdescripcion") and not isdefined("form.filtro_Cdescripcion") >
	<cfset form.filtro_Cdescripcion = url.filtro_Cdescripcion >
</cfif>	

<!--- ==================================================================================== --->
<!--- ==================================================================================== --->

<!--- 	DEFINICION DEL MODO --->
<cfset modo="ALTA">
<cfif isdefined("Form.EMid") and len(trim(form.EMid))>
	<cfset modo="CAMBIO">
<cfelseif isdefined("url.EMid") and len(trim(url.EMid))>
	<cfset modo="CAMBIO">
    <cfset Form.EMid=url.EMid>
</cfif>

<cfif isdefined("url.ECid") and len(trim(url.ECid))>
    <cfset Form.ECid=url.ECid>
</cfif>


<!--- 	CONSULTAS --->

	<cfquery name="rsDatos" datasource="#Session.DSN#">
        select a.ECid,
			a.ECdescripcion, <!--- estado de cuenta --->
			c.Bdescripcion, <!--- banco --->
			b.CBid, b.CBcodigo, b.CBdescripcion, <!--- cuenta bancaria --->
			d.Cformato,  <!--- formato de cuenta --->
			a.Bid,
            m.Mnombre, b.Mcodigo	
        from ECuentaBancaria a
        inner join CuentasBancos b
        	on  b.CBid = a.CBid 
        inner join Bancos c 
        	on c.Bid = b.Bid 
        inner join CContables d 
        	on d.Ccuenta = b.Ccuenta   
        inner join Monedas m 
			on m.Mcodigo = b.Mcodigo
        where b.Ecodigo = #Session.Ecodigo#
        <!---Tarjeta de Credito 1 o CuentasBancarias 0--->	
          and b.CBesTCE = #LvarCBesTCE#
          and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
	</cfquery>
    

	<cfquery name="rsPeriodoAux" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 50
    </cfquery>
    
    <cfquery name="rsMesAux" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 60
    </cfquery>
    
    <cfset LvarPeriodoAux=rsPeriodoAux.Pvalor>
    <cfset LvarMesAux=rsMesAux.Pvalor>
    <cfif rsMesAux.Pvalor eq 1>
    	<cfset LvarMesAuxAnt=12>
        <cfset LvarPeriodoAuxAnt=rsPeriodoAux.Pvalor-1> 
    <cfelse>    
    	<cfset LvarMesAuxAnt=rsMesAux.Pvalor-1>
        <cfset LvarPeriodoAuxAnt=rsPeriodoAux.Pvalor> 
    </cfif>
    <cfset LvarFecha='#LvarPeriodoAux#-#LvarMesAux#-01'>
    <cfset LvarFechaAnt='#LvarPeriodoAuxAnt#-#LvarMesAuxAnt#-01'>

	<cfquery name="rsPeriodoCont" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 30
    </cfquery>
    
    <cfquery name="rsMesCont" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 40
    </cfquery>
    
    <cfset LvarPeriodoCont=rsPeriodoCont.Pvalor>
    <cfset LvarMesCont=rsMesCont.Pvalor>
    <cfset LvarFechaCont='#LvarPeriodoCont#-#LvarMesCont#-01'>
    
    <!---Trae la moneda local--->
    <cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
        select Mcodigo from Empresas 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>


    <cfif rsMonedaEmpresa.Mcodigo neq rsDatos.Mcodigo>
        <cfquery name="rsTipoCambio" datasource="#session.DSN#">
            select Mes,TCEtipocambio,TCEtipocambioventa,TCEtipocambioprom
            from TipoCambioEmpresa 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPeriodoAuxAnt#">
              <!---and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">--->
              and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Mcodigo#">
              order by Mes desc
        </cfquery>
        <cfset LvarTC= rsTipoCambio.TCEtipocambio>
    <cfelse>
        <cfset LvarTC= 1>
    </cfif>                  

    
<!--- 	CONSULTA DE ENCABEZADO --->
<cfset Aplicar = "">
<cfif modo neq "ALTA">
	<cfset varCBesTCE=0>
		<cfif isdefined('LvarTCE')><!---  varTCE  indica si el query es para TCE o bancos--->
				<cfset varCBesTCE=1>
		</cfif>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select 
			a.EMid, 
			a.ts_rversion, 
			a.EMdocumento, 
			a.EMusuario,
			a.EMdescripcion, 
			a.EMfecha, 
			a.BTid, 
			b.Bid, 
			b.Ocodigo, 
			b.CBid, 
			b.CBcodigo, 
			b.CBdescripcion, 
			c.Mcodigo, 
			c.Mnombre, 
			a.EMtipocambio, 
			a.EMreferencia, 
			a.EMtotal,
			a.SNid,
			a.SNcodigo,
			a.id_direccion,
			coalesce(a.TpoSocio,0) as TpoSocio,
			a.TpoTransaccion,
			a.Documento,
			d.BTtipo,
			a.CDCcodigo	
		from EMovimientos a
			inner join CuentasBancos b
				on b.Ecodigo	=	a.Ecodigo
				and b.CBid		=	a.CBid
			inner join  Monedas c
				on c.Ecodigo 	= 	b.Ecodigo
				and c.Mcodigo 	=	b.Mcodigo
			inner join  BTransacciones d
				on a.Ecodigo 	= 	d.Ecodigo
				and a.BTid   	=	d.BTid	
		where a.EMid 			= 	<cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
        and b.CBesTCE           =   <cfqueryparam value="#varCBesTCE#" cfsqltype="cf_sql_bit"> 
		and a.Ecodigo			=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	</cfquery>
	<!--- 	CONSULTA SI EL MOVIMIENTO TIENE LINEAS PARA PERMITIR APLICAR --->
	<cfquery datasource="#Session.DSN#" name="rsFormLineas">
		select 1 as lineas 
		from DMovimientos
		  where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsFormLineas.recordcount GT 0>
		<cfif isdefined('LvarTCE')>
			<cfset Aplicar = ", Aplicar">
		<cfelse>
			<cfset Aplicar = ", Aplicar, Imprimir">
		</cfif>
		
	</cfif>
</cfif>

	<!--- 	TRANSACCIONES BANCARIAS --->
	<cfset varCBesTCE=0><!---  varTCE  indica si es para para TCE o bancos--->
		<cfif isdefined('LvarTCE')>
			<cfset varCBesTCE=1>
		</cfif>
		
<cfquery datasource="#Session.DSN#" name="rsBTransacciones">
	select BTid, BTtipo, 
			case 
				when BTtipo = 'C' then '-CR: ' else '+DB: '
			end
			<cf_dbfunction name="OP_concat">
			BTdescripcion
			as BTdescripcion
	from BTransacciones
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and BTtce=<cfqueryparam value="#varCBesTCE#" cfsqltype="cf_sql_bit" >
	order by 2 desc
</cfquery>

<!--- 	BANCOS --->
<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid, Bdescripcion 
	from Bancos 
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
    and Bid = #rsDatos.Bid#
	order by 2
</cfquery>

<!--- 	CONSULTA DEL DETALLE --->
<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	<cfset dmodo="ALTA"><cfif isdefined("Form.DMlinea") and len(trim(form.DMlinea))><cfset dmodo="CAMBIO"></cfif>
	<cfif dmodo neq "ALTA">
		<cfquery datasource="#Session.DSN#" name="rsDForm">	
			select a.EMid, a.DMlinea, a.ts_rversion, 
				a.DMdescripcion, a.Ccuenta,a.CFcuenta, a.DMmonto, 
				b.Cformato, b.Cdescripcion, 
				c.CFid, c.CFcodigo, c.CFdescripcion
				,cpt.TESRPTCid, cpt.SNid, cpt.TESBid, cpt.CDCcodigo
			from DMovimientos a
				inner join CContables b
					on b.Ccuenta = a.Ccuenta
				left outer join CFuncional c
					on c.CFid = a.CFid
				left join TESRPTcontables cpt
					 on cpt.EMid	= a.EMid
					and cpt.Dlinea	= a.DMlinea
			where a.EMid    			= <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric"> 
				and a.DMlinea 			= <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric">
				and a.Ecodigo			= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		</cfquery>
	</cfif>
</cfif>
<!--- 	CONTABILIZACION MANUAL O AUTOMÁTICA 
		CONTABILIZAR AUTOMATICAMENTE (Pvalor = N) IMPLICA REQUERIR EL CF Y NO LA CUENTA Y VICEVERSA
--->
<cfquery name="rsIndicador" datasource="#session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >	
		and Pcodigo = 2 
</cfquery>
<cfset ContabilizaAutomatico = false>
<cfif rsIndicador.recordcount gt 0 and rsIndicador.Pvalor eq "N">
	<cfset ContabilizaAutomatico = true>
</cfif>

<script language="JavaScript" src="../../js/fechas.js"></script> 

<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
function ajaxFunction_Direccion(){
	var ajaxRequest;  // The variable that makes Ajax possible!
	var vSNid ='';
	vSNid = document.form1.SNid.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest.open("GET", '/cfmx/sif/Utiles/SNDireccion_Combo.cfm?SNid='+vSNid, false);
	ajaxRequest.send(null);
	document.getElementById("contenedor_direccion").innerHTML = ajaxRequest.responseText;
}

//-->
</script>

<!--- alert(document.getElementById('id_direccion').options[0].text); --->

			
<cfoutput>
<form action="#_PaginaSQL#" method="post" name="form1" style="border:0px;" onsubmit="return funcValidaForm();">
 
	<input name="LvarHoy" value="#LsDateFormat(now(),'DD/MM/YYYY')#" type="hidden">
	<input name="LvarFechaAux" value="#LsDateFormat(LvarFecha,'DD/MM/YYYY')#" type="hidden">
	<input name="LvarFechaContable" value="#LsDateFormat(LvarFechaCont,'DD/MM/YYYY')#" type="hidden">
    <input type="hidden" name="ECid" value="#Form.ECid#">
<cfif modo neq "ALTA">
	<input type="hidden" name="EMid" value="#rsForm.EMid#">
	<input type="hidden" name="EMusuario" value="#rsForm.EMusuario#">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" artimestamp="#rsForm.ts_rversion#"/>
	<input type="hidden" name="timestamp" value="#ts#">
</cfif>
<cfif isdefined("form.pagina")>
	<input type="hidden" name="pagina" value="#form.pagina#">
</cfif>
    <table width="98%" align="center"  border="0" cellspacing="0" cellpadding="1" style="border:0px;">
    	<tr>
        	<td class="subTitulo" align="center" bgcolor="##f5f5f5">Encabezado del Movimiento</td>
      	</tr>
    </table>
	<table width="98%"  border="3" cellspacing="0" cellpadding="1" align="center" style="border:0px;">
    	<tr>
        	<td nowrap><strong>Documento:</strong></td>
            <td>
            	<input type="text" name="EMdocumento" tabindex="1" maxlength="20" <cfif modo neq "ALTA">value="#rsForm.EMdocumento#"</cfif>>	
            </td>
        	<td nowrap><strong>Descripci&oacute;n:</strong></td>	
        	<td colspan="3">
				<input type="text" tabindex="2" name="EMdescripcion" maxlength="120" size="40" <cfif modo neq "ALTA">value="#rsForm.EMdescripcion#"</cfif> >	
			</td>
        </tr>	
        <tr>
        	<td nowrap><strong>Fecha:</strong></td>
            <td>
                <cfif modo neq "ALTA">
                    <cfset fecha =  LSDateFormat(rsForm.EMfecha,'dd/mm/yyyy')>
                <cfelse>
                    <cfset fecha = LSDateFormat(LvarFechaAnt,'dd/mm/yyyy')>
                </cfif>
                <cf_sifcalendario name="EMfecha" value="#fecha#" tabindex="3">	</td>
            <td nowrap><strong>Transacci&oacute;n Bco:</strong></td>
            <td colspan="3">
                <cfset LvarBTtipoSugerir = "">
                <select name="BTid" tabindex="4" onchange="if(selectedIndex != 0) asignatipo(options[selectedIndex].title);"> 
                    <option value="">-- Seleccione una Transacci&oacute;n --</option>
                    <cfloop query="rsBTransacciones">
                        <option  title="#rsBTransacciones.BTtipo#"  value="#rsBTransacciones.BTid#" <cfif modo neq "ALTA" and rsForm.BTid eq rsBTransacciones.BTid>selected</cfif>>#rsBTransacciones.BTdescripcion#</option>
                    </cfloop>
                </select>
                <input type="hidden" name="BTtipo" value="<cfif modo neq "ALTA">#rsForm.BTtipo#</cfif>">
                    </td>	
          	</tr>
          
			<tr>
            	<td nowrap><strong>Banco:</strong></td>
                <td>
					<input type="hidden" name="Bid" id="Bid" value="#rsDatos.Bid#" readonly="readonly" />    
                    #rsBancos.Bdescripcion#
                </td>
          	</tr>
			<tr>
                <td nowrap><strong>Cuenta Bancaria: </strong></td>
                <td>
					<input type="hidden" name="CBid" id="CBid" value="#rsDatos.CBid#" readonly="readonly" />    
					#rsDatos.CBcodigo# #rsDatos.CBdescripcion#
                </td>
                    
                <td nowrap><strong>Moneda:</strong></td>
                
                <td colspan="3">
					<input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsDatos.Mcodigo#" readonly="readonly" />    
					<input type="hidden" name="Mnombre" id="Mnombre" value="#rsDatos.Mnombre#" readonly="readonly" />    
                    #rsDatos.Mnombre#
                </td>
			</tr>
      		<tr>
                <td ><strong>Tipo de Cambio:</strong></td>
                <td>
                    <cfif isdefined('LvarTCE') AND LEN(TRIM(#LvarTCE#)) GT 0>	<!--- CON TARJETAS DE CREDITO--->
                        <cfif modo NEQ 'ALTA'>
                            <cfquery name="rsTipoCambioTCE" datasource="#session.dsn#">
                                 select round(coalesce((case when cb.Mcodigo = e.Mcodigo then 1.00 else tc.TCcompra end), 1.0000),4) as EMtipocambio
                                from CuentasBancos cb 
                                        inner join Moneda mo
                                            on cb.Mcodigo=mo.Mcodigo
                                      inner join CBTarjetaCredito tj
                                            on cb.CBTCid = tj.CBTCid
                                     inner join DatosEmpleado de
            
                                            on tj.DEid=de.DEid
                                     inner join Empresas e
                                            on e.Ecodigo = cb.Ecodigo
                                    left outer join Htipocambio tc
                                            on 	tc.Ecodigo = cb.Ecodigo
                                    and tc.Mcodigo = cb.Mcodigo
                                    and tc.Hfecha  <= <cfqueryparam value="#rsForm.EMfecha#" cfsqltype="cf_sql_date">
                                    and tc.Hfechah >  <cfqueryparam value="#rsForm.EMfecha#" cfsqltype="cf_sql_date">                                  
                                 where cb.Ecodigo=#session.Ecodigo# 
                                        and cb.CBesTCE = 1 
                                        and cb.CBid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	  
                            </cfquery>
                
                            <cf_monto name="EMtipocambio" value="#rsTipoCambioTCE.EMtipocambio#" modificable="false" tabindex="-1" decimales="4" >
                        <cfelse>
                            <cf_monto name="EMtipocambio" modificable="false" tabindex="-1" decimales="4">
                        </cfif>
                    <cfelse>	
                        <!--- CON CUENTAS BANCARIAS--->
                        <input type="text" name="EMtipocambio" id="EMtipocambio" value="#LvarTC#" readonly="readonly" />  
                    </cfif>	
                </td>
                <td nowrap><strong>Tipo: </strong></td>
                <td colspan="3">
    
            	<cfif modo eq "ALTA">
                	<select name="TpoSocio" tabindex="1" onchange="javascript: verTR(); LimpiarCampos();">
                        <option value="0">Bancos</option>
                        <!---<option value="1">Movimientos Cliente</option>
                        <option value="2">Movimientos Proveedor</option>
                         <option value="3">Mov. Documentos Cliente</option>
                        <option value="4">Mov. Documentos Proveedor</option> --->
                    </select>
              	<cfelse>
                	<cfif len(trim(Aplicar))>
                        <cfswitch expression="#rsForm.TpoSocio#">
                            <cfcase value="0">
                                Bancos
                            </cfcase>
                            <cfcase value="1">
                                Movimientos Cliente
                            </cfcase>
                            <cfcase value="2">
                                Movimientos Proveedor
                            </cfcase>
                            <cfcase value="3">
                                Mov. Documentos Proveedor
                            </cfcase>
                            <cfcase value="4">
                                Mov. Documentos Proveedor
                            </cfcase>
                        </cfswitch>
                    	<input type="hidden" name="TpoSocio" value="#rsForm.TpoSocio#"/>	
                	<cfelse>
                        <select name="TpoSocio" tabindex="1" onchange="javascript: verTR(); LimpiarCampos();">
                            <option value="0" <cfif rsForm.TpoSocio eq 0>selected</cfif>>Bancos</option>
                            <option value="1" <cfif rsForm.TpoSocio eq 1>selected</cfif>>Cliente</option>
                            <option value="2" <cfif rsForm.TpoSocio eq 2>selected</cfif>>Proveedor</option>
                            <!--- <option value="3" <cfif rsForm.TpoSocio eq 3>selected</cfif>>Mov. Documentos Cliente</option>
                            <option value="4" <cfif rsForm.TpoSocio eq 4>selected</cfif>>Mov. Documentos Proveedor</option> --->
                        </select>
					</cfif>
            	</cfif>	
			</td>	
		</tr>
      	<tr>

			<td nowrap><strong>Referencia:</strong></td>
            <td>
                <input type="text" tabindex="1" name="EMreferencia" maxlength="25" <cfif modo neq "ALTA">value="#rsForm.EMreferencia#"</cfif>>	
			</td>
            <td nowrap><strong>Total:</strong></td>
            <td colspan="3">
				<cfif modo neq "ALTA">
                    <cf_monto name="EMtotal" value="#rsForm.EMtotal#" modificable="false">
                <cfelse>
                    <cf_monto name="EMtotal" modificable="false">
                </cfif>	
			</td>
		</tr>
    
		<tr id="TR_TIPO">
            <td nowrap><strong>Socio de Negocio:</strong></td>
            <td>
            	<cfset valuesArraySN = ArrayNew(1)>
                <cfif modo neq "ALTA" and rsForm.TpoSocio neq 0>
                    <cfquery datasource="#Session.DSN#" name="rsSN">
                        select SNid,SNcodigo,SNidentificacion,SNnumero,SNnombre
                        from SNegocios
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and  SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.SNcodigo#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArraySN, rsSN.SNid)>
                    <cfset ArrayAppend(valuesArraySN, rsSN.SNcodigo)>
                    <cfset ArrayAppend(valuesArraySN, rsSN.SNidentificacion)>
                    <cfset ArrayAppend(valuesArraySN, rsSN.SNnumero)>
                    <cfset ArrayAppend(valuesArraySN, rsSN.SNnombre)>
                </cfif>	
                
            
                <cf_conlis
                Campos="SNid,SNcodigo,SNidentificacion,SNnumero,SNnombre"
                valuesArray="#valuesArraySN#"
                Desplegables="N,N,N,S,S"
                Modificables="N,N,N,S,N"
                Size="0,0,0,10,30"
                tabindex="10"
                Title="Lista de Socios de Negocio"
                Tabla="SNegocios"
                Columnas="SNid,SNcodigo,SNidentificacion,SNnumero,SNnombre"
                Filtro=" Ecodigo = #Session.Ecodigo#  and SNtiposocio != $SNtiposocio,char$ order by SNnumero, SNnombre "
                Desplegar="SNnumero,SNidentificacion,SNnombre"
                Etiquetas="C&oacute;digo,Identificaci&oacute;n,Nombre"
                filtrar_por="SNnumero,SNidentificacion,SNnombre"
                Formatos="S,S,S"
                Align="left,left,left"
                form="form1"
                Asignar="SNid,SNcodigo,SNnumero,SNnombre"
                Asignarformatos="S,S,S,S"
                Funcion="ajaxFunction_Direccion()"/>
                
            </td>
            <td><strong>Dirección:</strong></td>
        	<td colspan="3">
                <cfquery datasource="#Session.DSN#" name="rsSN">
                    select id_direccion, SNnombre as nombre, SNDtelefono
                    from SNDirecciones
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    <cfif modo neq "ALTA" and len(trim(rsForm.SNid))>
                        and  SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.SNid#">
                    <cfelse>
                        and 1 = 2
                    </cfif>
                    order by SNnombre
                </cfquery>
                <span id="contenedor_direccion">
                    <select name="id_direccion" id="id_direccion" tabindex="1">
                        <cfloop query="rsSN">
                            <option value="#id_direccion#" <cfif id_direccion eq rsform.id_direccion>selected="selected"</cfif>>#nombre#</option>
                        </cfloop>
                    </select>
                </span>
            </td>
		</tr>
      	<!--- tipo 1 ---> 
      	<tr id="TR_TIPO2">
        	<td nowrap><strong> Transacción Destino:</strong></td>
        	<td>
				<cfset valuesArrayCCT = ArrayNew(1)>
                <cfif modo neq "ALTA" and rsForm.TpoSocio eq 1>
                    <cfquery datasource="#Session.DSN#" name="rsCCT">
                        select CCTcodigo,CCTdescripcion
                        from CCTransacciones
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArrayCCT, rsCCT.CCTcodigo)>
                    <cfset ArrayAppend(valuesArrayCCT, rsCCT.CCTdescripcion)>
                </cfif>
                
                <cf_conlis
                Campos="CCTcodigo,CCTdescripcion"
                Desplegables="S,S"
                valuesArray="#valuesArrayCCT#"
                Modificables="S,N"
                Size="2,43"
                tabindex="11"
                Title="Lista de tipos de transacciones cliente"
                Tabla="CCTransacciones "
                Columnas="CCTcodigo,CCTdescripcion"
                Filtro=" Ecodigo = #Session.Ecodigo#  and  CCTtipo != $BTtipo,char$"
                Desplegar="CCTcodigo,CCTdescripcion"
                Etiquetas="C&oacute;digo,Descripci&oacute;n"
                filtrar_por="CCTcodigo,CCTdescripcion"
                Formatos="S,S"
                Align="left,left"
                form="form1"
                Asignar="CCTcodigo,CCTdescripcion"
                Asignarformatos="S,S"/>	
            </td>
            <td align="left"><strong>Cliente POS:&nbsp;</strong></td>
            <td colspan="3" align="left">
                <cfif isdefined('rsForm') and len(trim(rsForm.CDCcodigo))>
                    <cf_sifClienteDetCorp CDCcodigo="CDCcodigo" form='form1' idquery="#rsForm.CDCcodigo#" size="20">
                <cfelse>
                    <cf_sifClienteDetCorp CDCcodigo="CDCcodigo" form='form1' size="20">
                </cfif>
            </td>
            <!--- <td colspan="4">&nbsp;</td> --->
		</tr>  
     	<!--- tipo 2 --->  
     	<tr id="TR_TIPO3">
        	<td nowrap><strong>Transacción Destino:</strong></td>
            <td>
                <cfset valuesArrayCPT = ArrayNew(1)>
                <cfif modo neq "ALTA" and rsForm.TpoSocio eq 2>
                    <cfquery datasource="#Session.DSN#" name="rsCPT">
                        select CPTcodigo,CPTdescripcion
                        from CPTransacciones
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and  CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArrayCPT, rsCPT.CPTcodigo)>
                    <cfset ArrayAppend(valuesArrayCPT, rsCPT.CPTdescripcion)>
                </cfif>
                
                <cf_conlis
                    Campos="CPTcodigo,CPTdescripcion"
                    Desplegables="S,S"
                    Modificables="S,N"
                    valuesArray="#valuesArrayCPT#"
                    Size="2,43"
                    tabindex="12"
                    Title="Lista de tipos de transacciones Proveedor"
                    Tabla="CPTransacciones "
                    Columnas="CPTcodigo,CPTdescripcion"
                    Filtro=" Ecodigo = #Session.Ecodigo# and  CPTtipo != $BTtipo,char$"
                    Desplegar="CPTcodigo,CPTdescripcion"
                    Etiquetas="C&oacute;digo,Descripci&oacute;n"
                    filtrar_por="CPTcodigo,CPTdescripcion"
                    Formatos="S,S"
                    Align="left,left"
                    form="form1"
                    Asignar="CPTcodigo,CPTdescripcion"
                    Asignarformatos="S,S"/>	
            </td>
            <td colspan="4">&nbsp;</td>
		</tr>  
      	<!--- tipo 3 --->
      	<tr id="TR_TIPO4">
        	<td nowrap><strong> Transacción Destino:</strong></td>
        	<td>
				<cfset valuesArrayCCTD = ArrayNew(1)>
                <cfif modo neq "ALTA" and rsForm.TpoSocio eq 3>
                    <cfquery datasource="#Session.DSN#" name="rsCCT">
                        select CCTcodigo,CCTdescripcion
                        from CCTransacciones
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArrayCCTD, rsCCT.CCTcodigo)>
                    <cfset ArrayAppend(valuesArrayCCTD, rsCCT.CCTdescripcion)>
                </cfif>
                
                <cf_conlis
                Campos="CCTcodigoD,CCTdescripcionD"
                Desplegables="S,S"
                valuesArray="#valuesArrayCCTD#"
                Modificables="S,N"
                Size="2,43"
                tabindex="13"
                Title="Lista de tipos de transacciones cliente"
                Tabla="CCTransacciones "
                Columnas="CCTcodigo as CCTcodigoD,CCTdescripcion as CCTdescripcionD"
                Filtro=" Ecodigo = #Session.Ecodigo#  and  CCTtipo = $BTtipo,char$"
                Desplegar="CCTcodigoD,CCTdescripcionD"
                Etiquetas="C&oacute;digo,Descripci&oacute;n"
                filtrar_por="CCTcodigo,CCTdescripcion"
                Formatos="S,S"
                Align="left,left"
                form="form1"
                Asignar="CCTcodigoD,CCTdescripcionD"
                Asignarformatos="S,S"/>	
            </td>
            <td><strong>Documento:</strong></td>
            <td colspan="3">
                <cfset valuesArrayDC = ArrayNew(1)>
                <cfif modo neq "ALTA" and rsForm.Documento neq "">
                    <cfquery datasource="#Session.DSN#" name="rsDC">
                        select Ddocumento as DocumentoC,Dsaldo as Dsaldo
                        from Documentos
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
                        and  Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
                        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.SNcodigo#">
                        and Dsaldo >=  <cfqueryparam cfsqltype="cf_sql_float" value="#rsForm.EMtotal#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArrayDC, rsDC.DocumentoC)>
                    <cfset ArrayAppend(valuesArrayDC, rsDC.Dsaldo)>
                </cfif>
                <cf_conlis
                Campos="DocumentoC,DsaldoC"
                Desplegables="S,S"
                valuesArray="#valuesArrayDC#"
                Modificables="S,N"
                Size="25,25"
                tabindex="14"
                Title="Lista de Documentos"
                Tabla="Documentos "
                Columnas="Ddocumento as DocumentoC,Dsaldo as DsaldoC"
                Filtro=" Ecodigo = #Session.Ecodigo#  and  CCTcodigo = $CCTcodigoD,char$ and SNcodigo = $SNcodigo,numeric$ and Mcodigo = $Mcodigo,numeric$ and Dsaldo >= $EMtotal,money$"
                Desplegar="DocumentoC,DsaldoC"
                Etiquetas="Documento,Salado"
                filtrar_por="Ddocumento,Dsaldo"
                Formatos="S,M"
                Align="left,left"
                form="form1"
                Asignar="DocumentoC,DsaldoC"
                Asignarformatos="S,M"/>			
            </td>
		</tr> 
        <!--- tipo 4 --->   
     	<tr id="TR_TIPO5">
        	<td nowrap><strong>Transacción Destino:</strong></td>
            <td>
                <cfset valuesArrayCPTD = ArrayNew(1)>
                <cfif modo neq "ALTA" and rsForm.TpoSocio eq 4>
                    <cfquery datasource="#Session.DSN#" name="rsCPT">
                        select CPTcodigo,CPTdescripcion
                        from CPTransacciones
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and  CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArrayCPTD, rsCPT.CPTcodigo)>
                    <cfset ArrayAppend(valuesArrayCPTD, rsCPT.CPTdescripcion)>
                </cfif>
                
                <cf_conlis
                    Campos="CPTcodigoD,CPTdescripcionD"
                    Desplegables="S,S"
                    Modificables="S,N"
                    valuesArray="#valuesArrayCPTD#"
                    Size="2,43"
                    tabindex="15"
                    Title="Lista de tipos de transacciones Proveedor"
                    Tabla="CPTransacciones "
                    Columnas="CPTcodigo as CPTcodigoD ,CPTdescripcion as CPTdescripcionD"
                    Filtro=" Ecodigo = #Session.Ecodigo# and  CPTtipo = $BTtipo,char$"
                    Desplegar="CPTcodigoD,CPTdescripcionD"
                    Etiquetas="C&oacute;digo,Descripci&oacute;n"
                    filtrar_por="CPTcodigo,CPTdescripcion"
                    Formatos="S,S"
                    Align="left,left"
                    form="form1"
                    Asignar="CPTcodigoD,CPTdescripcionD"
                    Asignarformatos="S,S"/>	
            </td>
            <td><strong>Documento:</strong></td>
            <td colspan="3">
                <cfset valuesArrayDP = ArrayNew(1)>
                <cfif modo neq "ALTA" and rsForm.Documento neq "">
                    <cfquery datasource="#Session.DSN#" name="rsDC">
                        select Ddocumento as DocumentoP,EDsaldo as DsaldoP
                        from EDocumentosCP
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and  CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
                        and  Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
                        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.SNcodigo#">
                        and EDsaldo >=  <cfqueryparam cfsqltype="cf_sql_float" value="#rsForm.EMtotal#">
                    </cfquery>
                    <cfset ArrayAppend(valuesArrayDP, rsDC.DocumentoP)>
                    <cfset ArrayAppend(valuesArrayDP, rsDC.DsaldoP)>
                </cfif>		<cf_conlis
                Campos="DocumentoP,DsaldoP"
                Desplegables="S,S"
                Modificables="S,N"
                Size="25,25"
                valuesArray="#valuesArrayDP#"
                tabindex="8"
                Title="Lista de Documentos"
                Tabla="EDocumentosCP "
                Columnas="Ddocumento as DocumentoP,EDsaldo as DsaldoP"
                Filtro=" Ecodigo = #Session.Ecodigo#  and  CPTcodigo = $CPTcodigoD,char$ and SNcodigo = $SNcodigo,numeric$ and Mcodigo = $Mcodigo,numeric$ and EDsaldo >= $EMtotal,money$"
                Desplegar="DocumentoP,DsaldoP"
                Etiquetas="Documento,Salado"
                filtrar_por="Ddocumento,EDsaldo"
                Formatos="S,M"
                Align="left,left"
                form="form1"
                Asignar="DocumentoP,DsaldoP"
                Asignarformatos="S,M"/>			
            </td>
		</tr>
	</table>
	<input type="hidden" name="SNtiposocio" value=""/>
	<br>
<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	<cfif dmodo neq "ALTA">
        <input type="hidden" name="DMlinea" value="#rsDForm.DMlinea#">
        <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsd" artimestamp="#rsDForm.ts_rversion#"/>
        <input type="hidden" name="timestampdet" value="#tsd#">
    </cfif>
    <table width="98%" align="center" border="0" cellspacing="0" cellpadding="1"  style="border:0px;">
      <tr>
        <td class="subTitulo" align="center" bgcolor="##f5f5f5">Detalles del Movimiento</td>
      </tr>
    </table>
    <table width="98%" align="center" cellspacing="2" cellpadding="0"  style="border:0px;">
    	<tr>
        	<td>
                <strong>Descripci&oacute;n:</strong>
            </td>
            <td>
                <input type="text" name="DMdescripcion" maxlength="120" tabindex="1" size="40" <cfif dmodo neq "ALTA">value="#rsDForm.DMdescripcion#"</cfif>>
            </td>
            <td><strong>Centro Funcional:</strong></td>
            <td>
                <cfif dmodo neq "ALTA" and len(rsDForm.CFid)>
                    <cf_rhcfuncional size="30" tabindex="16" titulo="Seleccione el Centro Funcional" query="#rsDForm#">
                <cfelse>
                    <cf_rhcfuncional size="30" tabindex="17" titulo="Seleccione el Centro Funcional">
                </cfif>		
            </td>
		</tr>
      	<tr>
        	<td nowrap>
				<cfif ContabilizaAutomatico>&nbsp;<cfelse><strong>Cuenta Contable:</strong></cfif>
            </td>
			<cfif ContabilizaAutomatico>
                <td style="display:none">
                    <cf_cuentas tabindex="19" cf_conceptoPago="TESRPTCid" >
                </td>
            <cfelse>
                <td>
                    <cfif dmodo NEQ "ALTA">
                        <cf_cuentas query="#rsDForm#" tabindex="18" cf_conceptoPago="TESRPTCid">
                    <cfelse>
                        <cf_cuentas tabindex="19" cf_conceptoPago="TESRPTCid">
                    </cfif>
                </td>
            </cfif>
            <td nowrap><strong>Monto:</strong></td>
            <td>
				<cfif dmodo neq "ALTA">
                    <cf_monto name="DMmonto" value="#rsDForm.DMmonto#" tabindex="20" negativos="true">
                <cfelse>
                    <cf_monto name="DMmonto" tabindex="21"  negativos="true" >
                </cfif>
            </td>
		</tr>
        <tr>
        	<td></td>
            <td colspan="3">
				<cfif dmodo neq "ALTA">
                
                  <cf_conceptoPago 	name="TESRPTCid" 	value="#rsDForm.TESRPTCid#" 
                                        SNid="#rsDForm.SNid#" TESBid="#rsDForm.TESBid#" CDCcodigo="#rsDForm.CDCcodigo#" 
                                        Bid="" CFcuenta="#rsDForm.CFcuenta#">
        
                <cfelse>
            
                    <cf_conceptoPago name="TESRPTCid" value="" SNid="" TESBid="" CDCcodigo="" Bid="" CFcuenta="">
            
                </cfif>
            </td>
        
		</tr>
	</table>
    <br>
</cfif>
<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	<cf_botones tabindex="22" modo="#modo#" mododet="#dmodo#" include="#Aplicar#" exclude="Nuevo" Genero="M" nameEnc="Movimiento">
<cfelseif modo neq "ALTA" and rsForm.TpoSocio neq 0>
	<cfif isdefined('LvarTCE')>
		<cfset Aplicar = ", Aplicar">
	<cfelse>
		<cfset Aplicar = ", Aplicar, Imprimir">
	</cfif>
	
	<cf_botones tabindex="23" modo="#modo#" include="#Aplicar#" Genero="M" nameEnc="Movimiento">
<cfelseif modo eq "ALTA" >
	<cf_botones tabindex="24" modo="#modo#" include="" Genero="M" nameEnc="Movimiento">
</cfif>

<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	<!--- ==================================================================================== --->
	<!--- MANTENER LOS FILTROS DE LA LISTA --->
	<!--- ==================================================================================== --->
	
		<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >#form.pagenum_lista#<cfelse>1</cfif>" />
		
		<cfif isdefined("form.pagenum_lista2") >
			<input type="hidden" name="pagenum_lista2" value="#form.pagenum_lista2#" />	
		</cfif>	
		<cfif not isdefined('LvarTCE')>
		<cfif isdefined("form.filtro_DMdescripcion") >
			<input type="hidden" name="filtro_DMdescripcion" value="#form.filtro_DMdescripcion#" />	
		</cfif>	
		</cfif>
		<cfif isdefined("form.filtro_Cdescripcion") >
			<input type="hidden" name="filtro_Cdescripcion" value="#form.filtro_Cdescripcion#" />	
		</cfif>	
	
	
		<cfif isdefined("form.filtro_EMdocumento") >
			<input type="hidden" name="filtro_EMdocumento" value="#trim(form.filtro_EMdocumento)#" />
		</cfif>
		<cfif isdefined("form.filtro_CBid") >
			<input type="hidden" name="filtro_CBid" value="#form.filtro_CBid#" />
		</cfif>
		<cfif isdefined("form.filtro_BTid") >
			<input type="hidden" name="filtro_BTid" value="#form.filtro_BTid#" />
		</cfif>
		<cfif isdefined("form.filtro_EMdescripcion") >
			<input type="hidden" name="filtro_EMdescripcion" value="#trim(form.filtro_EMdescripcion)#" />
		</cfif>
		<cfif isdefined("form.filtro_EMfecha") >
			<input type="hidden" name="filtro_EMfecha" value="#trim(form.filtro_EMfecha)#" />
		</cfif>
		<cfif isdefined("form.filtro_usuario") >
			<input type="hidden" name="filtro_usuario" value="#form.filtro_usuario#" />
		</cfif>		
	<!--- ==================================================================================== --->
	<!--- ==================================================================================== --->
</cfif>
</form>


	<!--- ==================================================================================== --->
	<!--- MANTENER LOS FILTROS DE LA LISTA --->
	<!--- ==================================================================================== --->
	<cfset navegacionDetalle = '' >
	<form action="#_PaginaLista#" method="post" name="form2" style="border:0px;">
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >#form.pagenum_lista#<cfelse>1</cfif>" />
			<cfif isdefined("form.pagenum_lista") >
				<cfset navegacionDetalle = '&pagenum_lista=#form.pagenum_lista#' >
			<cfelse>
				<cfset navegacionDetalle = '&pagenum_lista=1' >
			</cfif>
		
			<input type="hidden" name="btnNuevo" value="" />
			
			<cfif isdefined("form.filtro_EMdocumento") >
				<input type="hidden" name="filtro_EMdocumento" value="#trim(form.filtro_EMdocumento)#" />
				<cfset navegacionDetalle = navegacionDetalle & '&filtro_EMdocumento=#form.filtro_EMdocumento#' >
			</cfif>
			<cfif isdefined("form.filtro_CBid") >
				<input type="hidden" name="filtro_CBid" value="#form.filtro_CBid#" />
				<cfset navegacionDetalle = navegacionDetalle & '&filtro_CBid=#form.filtro_CBid#' >		
			</cfif>			
			<cfif isdefined("form.EMusuario") >			
				<cfset navegacionDetalle = navegacionDetalle & '&EMusuario=#form.EMusuario#' >		
			</cfif>
			
			<cfif isdefined("form.filtro_BTid") >
				<input type="hidden" name="filtro_BTid" value="#form.filtro_BTid#" />
				<cfset navegacionDetalle = navegacionDetalle & '&filtro_BTid=#form.filtro_BTid#' >		
			</cfif>
			<cfif isdefined("form.filtro_EMdescripcion") >
				<input type="hidden" name="filtro_EMdescripcion" value="#trim(form.filtro_EMdescripcion)#" />
				<cfset navegacionDetalle = navegacionDetalle & '&filtro_EMdescripcion=#form.filtro_EMdescripcion#' >		
			</cfif>
			<cfif isdefined("form.filtro_EMfecha") >
				<input type="hidden" name="filtro_EMfecha" value="#trim(form.filtro_EMfecha)#" />
				<cfset navegacionDetalle = navegacionDetalle & '&filtro_EMfecha=#form.filtro_EMfecha#' >		
			</cfif>
			<cfif isdefined("form.filtro_usuario") >
				<input type="hidden" name="filtro_usuario" value="#form.filtro_usuario#" />
				<cfset navegacionDetalle = navegacionDetalle & '&filtro_usuario=#form.filtro_usuario#' >		
			</cfif>			         
			<cfif isdefined("form.EMusuario") >
				<input type="hidden" name="EMusuario2" value="#form.EMusuario#" />
				<cfset navegacionDetalle = navegacionDetalle & '&EMusuario2=#form.EMusuario#' >		
			</cfif>
			
		</cfif>
	</form>
	<!--- ==================================================================================== --->
	<!--- ==================================================================================== --->

<cf_qforms form='form1'>
<script language="javascript" type="text/javascript">
	var monto = -1;
		verTR();
	   <cfif isdefined('LvarTCE')>
			objForm.CBTCDescripcion.description = "#JSStringFormat('Tarjeta de Cr\u00e9dito')#";
			objForm.CBTCDescripcion.required = true;

		<cfelse>
			objForm.Bid.description = "#JSStringFormat('Banco')#";
			objForm.Bid.required = true;
			objForm.CBid.description = "#JSStringFormat('Cuenta Bancaria')#";
			objForm.CBid.required = true;
		
		</cfif>			
	
		objForm.BTid.required=true;

	objForm.EMdocumento.description = "#JSStringFormat('Documento')#";
	objForm.EMdocumento.required = true;
	objForm.EMdescripcion.description = "#JSStringFormat('Descripción')#";
	objForm.EMdescripcion.required = true;
	objForm.EMfecha.description = "#JSStringFormat('Fecha')#";
	objForm.BTid.description = "#JSStringFormat('Transacción')#";
	objForm.EMreferencia.description = "#JSStringFormat('Referencia')#";
	objForm.EMreferencia.required = true;
	
<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	objForm.DMdescripcion.description = "#JSStringFormat('Descripción del Detalle')#";
	objForm.CFcodigo.description = "#JSStringFormat('Centro Funcional del Detalle')#";
	objForm.Ccuenta.description = "#JSStringFormat('Cuenta Contable del Detalle')#";
	objForm.DMmonto.description = "#JSStringFormat('Monto del Detalle')#";

</cfif>	
	
	objForm.Mnombre.description = "#JSStringFormat('Moneda')#";
	objForm.BTtipo.description = "#JSStringFormat('Transacción')#";
	objForm.SNid.description = "#JSStringFormat('Socio de Negocios')#";
	objForm.SNcodigo.description = "#JSStringFormat('Socio de Negocios')#";
	objForm.id_direccion.description = "#JSStringFormat('Dirección')#";
	objForm.DocumentoP.description = "#JSStringFormat('P Documento')#";
	objForm.DocumentoC.description = "#JSStringFormat('C Documento')#";
	
	
	objForm.CDCidentificacion.description =  "#JSStringFormat('Cliente')#";
	objForm.EMtotal.required = true;
	_addValidator("isCantidad", Cantidad_valida);
	objForm.EMtotal.validateCantidad();	

	objForm.BTtipo.required = true;

	
	if(document.form1.CCTcodigo)
		objForm.CCTcodigo.description = "#JSStringFormat('Tipo de Transacción')#";
	if(document.form1.CCTcodigoD)
		objForm.CCTcodigoD.description = "#JSStringFormat('Tipo de Transacción')#";
	if(document.form1.CPTcodigo)
	objForm.CPTcodigo.description = "#JSStringFormat('Tipo de Transacción')#";
	if(document.form1.CPTcodigoD)
	objForm.CPTcodigoD.description = "#JSStringFormat('Tipo de Transacción')#";
	objForm.EMtotal.description = "#JSStringFormat('Total')#";
	
	
	function verTR() {
		var tr = document.getElementById("TR_TIPO");
		var tr2 = document.getElementById("TR_TIPO2");
		var tr3 = document.getElementById("TR_TIPO3");
		var tr4 = document.getElementById("TR_TIPO4");
		var tr5 = document.getElementById("TR_TIPO5");
		var tabla  = document.getElementById("tabla");

		if (document.form1.TpoSocio.value != '0'){
			tr.style.display = "";
			document.form1.EMtotal.readOnly  = false;
			objForm.SNcodigo.required = true;
			objForm.id_direccion.required = true;
			if (tabla){
			tabla.style.display =  "none";	
			}
			<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
				alert('Para quitar los detalles del movimiento es necesario presionar el boton modificar el movimiento');
			</cfif>
		}
		else{
			tr.style.display =  "none";
			tr2.style.display =  "none";
			tr3.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "none";
			document.form1.EMtotal.readOnly  = true;
			objForm.SNcodigo.required = false;
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = false;
			objForm.id_direccion.required = false;
			<cfif modo neq "ALTA" and rsForm.TpoSocio neq 0>
				alert('Para poder agregar líneas es necesario presionar el boton modificar el movimiento');
			</cfif>
			
		}	
		document.form1.SNtiposocio.value = '';		
		if (document.form1.TpoSocio.value == '1') {
			document.form1.SNtiposocio.value = 'P';	
			tr2.style.display = "";
			tr3.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "none";
			objForm.CCTcodigo.required = true;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = false;

		}
		else if(document.form1.TpoSocio.value == '2'){
			document.form1.SNtiposocio.value = 'C';	
			tr3.style.display = "";
			tr2.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "none";
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = true;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = false;

		}
		else if(document.form1.TpoSocio.value == '3'){
			document.form1.SNtiposocio.value = 'P';	
			tr2.style.display = "none";
			tr3.style.display =  "none";
			tr4.style.display =  "";
			tr5.style.display =  "none";
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = true;
			objForm.CPTcodigoD.required = false;
			objForm.DocumentoC.required = true;
			objForm.DocumentoP.required = false;

		}
		else if(document.form1.TpoSocio.value == '4'){
			document.form1.SNtiposocio.value = 'C';	
			tr3.style.display = "none";
			tr2.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "";
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = true;
			objForm.DocumentoP.required = true;
			objForm.DocumentoC.required = false;
			
		}
	}

	function Cantidad_valida(){
		var TpoSocio = new Number(document.form1.TpoSocio.value)	
		var monto = new Number(this.value)	
		if ( TpoSocio != 0){
			if (monto <= 0)
				this.error = "El valor de Monto ser diferente de 0";
		}		
	}	
	
	function LimpiarCampos() {
		document.form1.SNcodigo.value = "";
		document.form1.SNidentificacion.value = "";
		document.form1.SNnombre.value = "";
		document.form1.DocumentoP.value = "";
		document.form1.DocumentoC.value = "";
		document.form1.CCTcodigo.value = "";
		document.form1.CCTdescripcion.value = "";
		document.form1.CPTcodigo.value = "";
		document.form1.CPTdescripcion.value = "";
		document.form1.CCTcodigoD.value = "";
		document.form1.CCTdescripcionD.value = "";
		document.form1.CPTcodigoD.value = "";
		document.form1.CPTdescripcionD.value = "";	
	}	
	
	function asignatipo(BTtipo) {
		document.form1.BTtipo.value = BTtipo;
	}
	

	function habilitarValidacion() {
	
	
		<cfif isdefined('LvarTCE')>
			objForm.CBTCDescripcion.required = true;
		<cfelse>
			objForm.Bid.required = true;
			objForm.CBid.required = true;
		</cfif>		
		
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
		objForm.DMdescripcion.required = true;
		objForm.CFcodigo.required = true;
		objForm.Ccuenta.required = true;
		</cfif>
		
		objForm.EMdocumento.required = true;
		objForm.EMdescripcion.required = true;
		objForm.EMfecha.required = true;
		
		objForm.BTid.required = true;
		

		objForm.Mnombre.required = true;
		objForm.EMtipocambio.required = true;
		objForm.EMreferencia.required = true;
		if (!btnSelected("Cambio", document.form1)){
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			objForm.allowSubmitOnError = false;
			<cfif not isdefined('LvarTCE')>
			objForm.DMdescripcion.required = true;
			</cfif>
			<cfif ContabilizaAutomatico>
				objForm.CFcodigo.required = true;
			<cfelse>
				 <cfif not isdefined('LvarTCE')>
				objForm.Ccuenta.required = true;
				</cfif>
			</cfif>
			objForm.DMmonto.required = true;
			objForm.DMmonto.validateExp("!objForm.allowSubmitOnError&&parseFloat(qf(this.getValue()))==0.00","El valor de Monto del Detalle debe ser diferente de 0");
		</cfif>
		}else{
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			objForm.allowSubmitOnError = true;
			<cfif not isdefined('LvarTCE')>
			objForm.DMdescripcion.required = false;
			
			</cfif>
			
			<cfif ContabilizaAutomatico>
				objForm.CFcodigo.required = false;
			<cfelse>
			 <cfif not isdefined('LvarTCE')>
				objForm.Ccuenta.required = false;
				</cfif>
			</cfif>
			objForm.DMmonto.required = false;
		</cfif>
		}
		if (document.form1.TpoSocio.value != '0'){
			if(document.getElementById('id_direccion').selectedIndex > -1)
				objForm.id_direccion.required = false;
			else
				objForm.id_direccion.required = true;
		}if (document.form1.TpoSocio.value == '1')
				objForm.CDCidentificacion.required = true;
			else
				objForm.CDCidentificacion.required = false;
	}
	function deshabilitarValidacion() {
	
		
		<cfif isdefined('LvarTCE')>
			objForm.CBTCDescripcion.required = false;
		<cfelse>
			objForm.Bid.required = false;
			objForm.CBid.required = false;
		</cfif>		
		
		objForm.DMdescripcion.required = false;

		
		objForm.BTid.required = false;
		objForm.CFcodigo.required = false;
		objForm.Ccuenta.required = false;
		
		objForm.EMdocumento.required = false;
		objForm.EMdescripcion.required = false;
		objForm.EMfecha.required = false;
		objForm.BTid.required = false;
		
		objForm.Mnombre.required = false;
		objForm.EMtipocambio.required = false;
		objForm.EMreferencia.required = false;

				
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			<cfif not isdefined('LvarTCE')>
			objForm.DMdescripcion.required = false;
			</cfif>
			<cfif ContabilizaAutomatico>
				objForm.CFcodigo.required = false;
			<cfelse>
				<cfif not isdefined('LvarTCE')>
				objForm.Ccuenta.required = false;
				</cfif>
			</cfif>
			objForm.DMmonto.required = false;
		</cfif>		
	}
	function limpiarCuenta(){
		objForm.CBid.obj.value="";
		objForm.CBcodigo.obj.value="";
		objForm.Mcodigo.obj.value="";
		objForm.Mnombre.obj.value="";
		objForm.EMtipocambio.obj.value="";
		
	}
	
	function funcValidaForm(){
		if (!objForm.EMdocumento.required)
			return true;
		
		if ((toFecha(document.form1.EMfecha.value) >= toFecha(document.form1.LvarFechaAux.value))){
			alert("La Fecha debe ser menor a " + document.form1.LvarFechaAux.value);
			return false;
		}
		
		if ((toFecha(document.form1.EMfecha.value) > toFecha(document.form1.LvarHoy.value))){
			alert("La Fecha debe ser menor o igual a " + document.form1.LvarHoy.value);
			return false;
		}
		
		if ((toFecha(document.form1.EMfecha.value) < toFecha(document.form1.LvarFechaContable.value))){
			alert("La Fecha debe ser mayor o igual a Periodo y Mes Contable " + document.form1.LvarFechaContable.value);
			return false;
		}
		
		<!---if (cf_conceptoPagoTESRPTCid_verif)
		{
			var TipoMov = (document.form1.BTtipo.value == "D") ? "C" : "D";
			return cf_conceptoPagoTESRPTCid_verif(TipoMov);
		}--->
		return true;
	}
	
	function funcRegresar(){
		document.form2.submit();
		return false;
	}
	
	function funcNuevo(){
		document.form2.action = "<cfoutput>#_Pagina#</cfoutput>";
		document.form2.submit();
		return false;
	}
	function FuncCambiarDireccion(){
		alert('Aqui tiene que refrescar las direcciones');
		return false;
	}

	verTR();
	<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
		<cfif not isdefined('LvarTCE')>
		objForm.DMdescripcion.obj.focus();
		</cfif>
	<cfelse>
		objForm.EMdocumento.obj.focus();
	</cfif>
	
	<cfif isdefined("Form.EMid") and not isdefined('LvarTCE') >
	function funcImprimir()
	{
		var url="popUp-RegistroMBperiodoAnterior-Imprimir.cfm";
		var parametros="?EMid=#Form.EMid#<cfif isdefined("form.EMusuario") >&EMusuario=#form.EMusuario#</cfif>";
		parametros+="&ECid=#Form.ECid#<cfif isdefined("form.CFID") >&CFID=#form.CFID#</cfif>&LvarCBesTCE=#LvarCBesTCE#";


		popUp(url+parametros);return false;
	}
	
	function popUp(URL) 
	{
		day = new Date();id = day.getTime();
		eval("page" + id + " = window.open(URL, '"+id+ "','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=950,height=600');");
	}
	</cfif>
</script>





<cfif isdefined('Form.EMid') and len(trim(Form.EMid)) and rsForm.TpoSocio eq 0>
		<table   id="tabla" width="98%" align="center"  border="0" cellspacing="0" cellpadding="0" style="border:0px;">
		  <tr>
			<td>
			<fieldset><legend>Lista de Detalles del Movimiento</legend>
			<cfset navegacion = "&EMid=#form.EMid#">
			<cfif isdefined("navegacionDetalle")>
				<cfset navegacion = "&EMid=#form.EMid##navegacionDetalle#">
			</cfif>
			
			<!--- ========================================= --->
			<!--- MANTIENE LOS FILTROS DE LA LISTA PRINCIPAL --->
			<!--- ========================================= --->
			<cfif isdefined("form.pagenum_lista") >
				<cfset camposExtra = "'#form.pagenum_lista#' as pagenum_lista" >
			<cfelse>
				<cfset camposExtra = "'1' as pagenum_lista" >
			</cfif>
			
			<cfif isdefined("form.filtro_EMdocumento") >
				<cfset camposExtra = camposExtra & " , '#form.filtro_EMdocumento#' as filtro_EMdocumento" >
			</cfif>
			<cfif isdefined("form.filtro_CBid") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_CBid#' as filtro_CBid">
			</cfif>
			<cfif isdefined("form.filtro_BTid") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_BTid#' as filtro_BTid">
			</cfif>
			<cfif isdefined("form.filtro_EMdescripcion") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_EMdescripcion#' as filtro_EMdescripcion">
			</cfif>
			<cfif isdefined("form.filtro_EMfecha") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_EMfecha#' as filtro_EMfecha">				
			</cfif>
			<cfif isdefined("form.filtro_usuario") >
				<cfset camposExtra = camposExtra & ", '#form.filtro_usuario#' as filtro_usuario">
			</cfif>
			<cfif isdefined("url.pagenum_lista2") and not isdefined("form.pagenum_lista2") >
				<cfset form.pagenum_lista2 = url.pagenum_lista2 >
			</cfif>
			<cfif isdefined("form.pagenum_lista2") >
				<cfset camposExtra = camposExtra & ", '#form.pagenum_lista2#' as pagenum_lista2">
			</cfif>
			
			<cfif isdefined("url.sqlDone")>
			<cfif not isdefined('LvarTCE')>
				<cfif isdefined("form.filtro_DMdescripcion") >
					<cfset form.hfiltro_DMdescripcion = form.filtro_DMdescripcion >
				</cfif>
			</cfif>	
				<cfif isdefined("form.filtro_Cdescripcion") >
					<cfset form.hfiltro_Cdescripcion = form.filtro_Cdescripcion >
				</cfif>
			</cfif>
			<cf_dbfunction name="concat" args="CFformato,' ',Cdescripcion" returnvariable="LvarCFdescripcion">
			<cf_dbfunction name="concat" args="Cformato,' ',Cdescripcion" returnvariable="LvarCdescripcion">
			
			<cfinvoke component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="DMovimientos dm 
				                                         inner join CContables cc
														  on  dm.Ccuenta=cc.Ccuenta 
														  left join CFinanciera cf 
														  on dm.CFcuenta = cf.CFcuenta"/>
				<cfinvokeargument name="columnas" value="DMlinea, EMid, DMdescripcion,  
									coalesce(CFformato,Cformato) as CFformato, 
									coalesce(CFdescripcion,Cdescripcion) as CFdescripcion, 
									DMmonto, #camposExtra#"/>
				<cfinvokeargument name="desplegar" value="DMdescripcion, CFformato, CFdescripcion, DMmonto"/>
				<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Cuenta, Descripci&oacute;n, Monto"/>
				<cfinvokeargument name="totales" value="DMmonto"/>
				<cfinvokeargument name="filtro" value="dm.EMid=#form.EMid# and dm.Ecodigo=#session.Ecodigo# order by DMlinea"/>
				<cfinvokeargument name="align" value="left, left, left, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="#_Pagina#?EMid=#form.EMid#&ECid=#form.ECid#"/>
				<cfinvokeargument name="keys" value="EMid, DMlinea"/>
				<cfinvokeargument name="PageIndex" value="2"/>
				<cfinvokeargument name="formatos" value="S, S, S, M"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="QueryString_lista" value="&#CGI.QUERY_STRING#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="maxrows" value="30"/>
			</cfinvoke>
			<cfoutput>
			<script language="javascript">
				function funcFiltrar2(){
					document.lista.EMID.value="#Form.EMid#";
					
					<cfif isdefined("form.filtro_EMdocumento") >
						document.lista.FILTRO_EMDOCUMENTO.value = '#JSStringFormat(form.filtro_EMdocumento)#';
					</cfif>
					<cfif isdefined("form.filtro_CBid") >
						document.lista.FILTRO_CBID.value = '#JSStringFormat(form.filtro_CBid)#';
					</cfif>
					<cfif isdefined("form.filtro_BTid") >
						document.lista.FILTRO_BTID.value = '#JSStringFormat(form.filtro_BTid)#';
					</cfif>
					<cfif isdefined("form.filtro_EMdescripcion") >
						document.lista.FILTRO_EMDESCRIPCION.value = '#JSStringFormat(form.filtro_EMdescripcion)#';
					</cfif>
					<cfif isdefined("form.filtro_EMfecha") >
						document.lista.FILTRO_EMFECHA.value = '#JSStringFormat(form.filtro_EMfecha)#';
					</cfif>
					<cfif isdefined("form.filtro_usuario") >
						document.lista.FILTRO_USUARIO.value = '#JSStringFormat(form.filtro_usuario)#';
					</cfif>
					<cfif isdefined("form.pagenum_lista") >
						document.lista.PAGENUM_LISTA.value = '#JSStringFormat(form.pagenum_lista)#';
					</cfif>

					<cfif isdefined("form.pagenum_lista2") >
						document.lista.PAGENUM_LISTA2.value = '#JSStringFormat(form.pagenum_lista2)#';
					</cfif>

					return true;
				}
				
				/* ============================ */
				<cfif not isdefined('LvarTCE')>
				document.lista.filtro_DMdescripcion.tabIndex = 4;
				</cfif>
				<!---document.lista.filtro_Cdescripcion.tabIndex = 4;--->
				document.lista.filtro_DMmonto.tabIndex = 4;
				//document.lista.Filtrar.tabIndex = 4;
			</script>
			</cfoutput>
			</fieldset>
			</td>
		  </tr>
		</table>
		<br>
		</cfif>




</cfoutput>