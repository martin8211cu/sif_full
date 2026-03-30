
<cfif isdefined("url.QPvtaTagid") and not isdefined("form.QPvtaTagid") and len(trim(url.QPvtaTagid))>
	<cfset form.QPvtaTagid = url.QPvtaTagid>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">

<cfset modo = 'Alta'>
<cfif isdefined("form.QPvtaTagid") and len(trim(form.QPvtaTagid)) and not isdefined("form.Nuevo") and not isdefined("form.BTNNUEVO")>
	<cfset modo = 'Cambio'>
</cfif>

<cfif modo neq 'Alta'>
    <cfquery name="rsQPventaTags" datasource="#session.DSN#">
    	select 
        a.QPvtaTagid, 
        a.QPTidTag, 
        b.QPTPAN,
        b.QPTNumSerie,
        c.QPcteNombre as cliente, 
        c.QPcteDocumento as identificacion,
        a.QPcteid,
        a.QPctaSaldosid, 
        f.QPctaBancoNum as cuentaBanco,
        a.QPvtaConvid, 
        a.QPvtaTagPlaca, 
        a.QPvtaTagCont, 
        a.QPvtaTagFact, 
        a.QPvtaTagFecha, 
        rtrim(e.Oficodigo) #_Cat# ' ' #_Cat# e.Odescripcion as sucursal,
        f.QPctaBancoNum,
        f.QPctaBancoid
    from QPventaTags a
        inner join QPassTag b
           on b.QPTidTag = a.QPTidTag
        inner join QPcliente c
           on c.QPcteid = a.QPcteid
        inner join QPcuentaSaldos d
            inner join QPcuentaBanco f
               on f.QPctaBancoid  = d.QPctaBancoid 
            on d.QPctaSaldosid = a.QPctaSaldosid
        inner join Oficinas e
           on e.Ecodigo = a.Ecodigo
         and e.Ocodigo = a.Ocodigo
    where QPvtaTagid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPvtaTagid#">
    and exists(
             select 1
             from QPassUsuarioOficina f
             where f.Usucodigo = #session.Usucodigo#
             and  f.Ecodigo = #session.Ecodigo#
             and f.Ecodigo = a.Ecodigo
             and f.Ocodigo = a.Ocodigo) 
    </cfquery>
</cfif>

<cf_templateheader title="SIF - Quick Pass">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Venta de Tags'>
		<cfoutput>
            <form name="form1" action="QPassVenta_SQL.cfm" method="post">
                <input name="QPvtaTagid" type="hidden" value="<cfif modo neq 'Alta'>#form.QPvtaTagid#</cfif>" tabindex="1"/>

                <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
                    <tr>
                    	<td align="right" width="40%">
                        	<strong>Placa:&nbsp;</strong>
                        </td>
                        <td align="left">
                        	<input name="QPvtaTagPlaca" type="text" value="<cfif modo neq 'Alta'>#rsQPventaTags.QPvtaTagPlaca#</cfif>" tabindex="1">
                        </td>
                    </tr>
                    <tr>
                    	<td align="right">
                        	<strong>Tag:</strong>&nbsp;
                        </td>
                        <td>
                        	<cfset valuesArray = ArrayNew(1)>
							<cfif isdefined("rsQPventaTags") and LEN(rsQPventaTags.QPTidTag) GT 0>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.QPTidTag)>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.QPTPAN)>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.QPTNumSerie)>
                            </cfif>
                            <cfinclude template="QPconlisTags.cfm">
                        </td>
                    </tr>
                    
                    <tr>
                        <td align="right">
                        	<strong>Cliente:&nbsp;</strong>
                        </td>
                        <td align="left">
                        	<cfset valuesArray = ArrayNew(1)>
							<cfif isdefined("rsQPventaTags") and LEN(rsQPventaTags.QPcteid) GT 0>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.QPcteid)>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.identificacion)>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.cliente)>
                            </cfif>
                            <cf_conlis
                                Campos="QPcteid, QPcteDocumento, QPcteNombre"
                                Desplegables="N,S,S"
                                Modificables="N,S,N"
                                Size="0,15,30"
                                tabindex="1"
                                valuesarray="#valuesArray#" 
                                Title="Lista de Clientes"
                                Tabla="QPcliente a 
                                		inner join QPtipoCliente b
                                        on b.QPtipoCteid = a.QPtipoCteid"
                                Columnas="a.QPcteid, a.QPcteDocumento, a.QPcteNombre, b.QPtipoCteDes"
                                Filtro=" a.Ecodigo = #session.Ecodigo#"
                                Desplegar="QPcteNombre, QPcteDocumento, QPtipoCteDes"
                                Etiquetas="Cliente, Identificación, Tipo Cliente"
                                filtrar_por="a.QPcteNombre, a.QPcteDocumento, b.QPtipoCteDes"
                                Formatos="S,S,S"
                                Align="left,left,left"
                                form="form1"
                                Asignar="QPcteid, QPcteDocumento, QPcteNombre"
                                Asignarformatos="S,S,S"
                                width="800"
                            />
                        </td>
                    </tr>
                    <tr>
                    	<td align="right">
                        	<strong>Cuenta:</strong>&nbsp;
                        </td>
                        <td align="left">
                        	<cfset valuesArray = ArrayNew(1)>
							<cfif isdefined("rsQPventaTags") and LEN(trim(rsQPventaTags.QPctaBancoNum)) GT 0>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.QPctaBancoid)>
                                <cfset ArrayAppend(valuesArray, rsQPventaTags.QPctaBancoNum)>
                            </cfif>
                            <cf_conlis
                                Campos="QPctaBancoid, QPctaBancoNum"
                                Desplegables="N,S"
                                Modificables="N,S"
                                Size="0,20"
                                tabindex="1"
                                valuesarray="#valuesArray#" 
                                Title="Lista de Cuentas"
                                Tabla="QPcuentaBanco a
                                		inner join Monedas b
                                        on b.Mcodigo = a.Mcodigo"
                                Columnas="a.QPctaBancoid, a.QPctaBancoTipo, a.QPctaBancoNum, a.QPctaBancoCC, b.Mnombre" 
                                Filtro=" a.Ecodigo = #session.Ecodigo# "
                                Desplegar="QPctaBancoNum, QPctaBancoTipo, QPctaBancoCC, Mnombre"
                                Etiquetas="Cuenta, Tipo, Cuenta Cliente, Moneda"
                                filtrar_por="a.QPctaBancoNum, a.QPctaBancoTipo, a.QPctaBancoCC, b.Mnombre"
                                Formatos="S,S,S,S"
                                Align="left,left,left,left"
                                form="form1"
                                Asignar="QPctaBancoid, QPctaBancoNum"
                                Asignarformatos="S,S,S"
                                width="800"
                            />
                        </td>
                    </tr>
                    <tr>
                    	<td align="right">
                        	<strong>Convenio:</strong>&nbsp;
                        </td>
                        <td align="left">
                        	<cfquery name="rsConvenio" datasource="#session.DSN#">
                            	select 
                                    QPvtaConvid,
                                    QPvtaConvCod,
                                    QPvtaConvDesc
                                from QPventaConvenio
                                where Ecodigo = #session.Ecodigo#
                            </cfquery>
                        	<select name="QPvtaConvid" tabindex="1">
                            	<cfloop query="rsConvenio">
                            		<option value="#rsConvenio.QPvtaConvCod#" <cfif modo NEQ 'Alta' and rsConvenio.QPvtaConvid eq rsQPventaTags.QPvtaConvid>selected="selected"</cfif>>#rsConvenio.QPvtaConvCod# - #rsConvenio.QPvtaConvDesc#</option>
								</cfloop>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                    	<td colspan="2" align="left">
                        	<cf_botones modo=#modo#>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="2" align="left">&nbsp;
                        	
                        </td>
                    </tr>
                    <tr>
	                    <td colspan="2">&nbsp;</td>
                    </tr>
                    
                </table>
            </form>
        </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>

<cf_qforms form="form1">
    <cf_qformsrequiredfield args="QPTidTag,Tag">
    <cf_qformsrequiredfield args="QPvtaTagPlaca,Placa">
    <cf_qformsrequiredfield args="QPcteid,Cliente">
    <cf_qformsrequiredfield args="QPctaBancoid,Cuenta">
    <cf_qformsrequiredfield args="QPvtaConvid,Convenio">
</cf_qforms>