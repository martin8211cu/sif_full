<cfinclude template="../../Utiles/sifConcat.cfm">

<form name="frmTES" style="margin:0;" method="post">
	<table cellpadding="0" cellspacing="6" background="0" width="80%" align="center">
	<tr>
		<td colspan="2">
			<strong>Tesorería:</strong>
			<cf_cboTESid tipo="" onChange="document.frmTES.submit();" tabindex="1">
		</td>
	</tr>
</table>
</form>

<form name="frmTESCB" style="margin:0;" method="post" action="tarjetasCredito_sql.cfm">
	<cfquery datasource="#session.dsn#" name="lista">
		select tcb.CBid, b.Bdescripcion,CBcodigo, mp.Miso4217, TESCBactiva
		 from CuentasBancos cp
         	inner join Bancos b
         		on b.Bid  = cp.Bid
         	inner join TEScuentasBancos tcb
         		on tcb.CBid  = cp.CBid
                and tcb.TESid = #session.Tesoreria.TESid#
         	inner join Monedas mp
                on mp.Ecodigo = cp.Ecodigo
                and mp.Mcodigo = cp.Mcodigo
			where cp.Ecodigo = #session.Ecodigo#
          	and cp.CBesTCE = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
        order by Bdescripcion
	</cfquery>
	
	<table cellpadding="0" cellspacing="0" background="0" width="80%" align="center" border="0">
		<tr>
        	<td></td>
        	<td><strong>Tarjeta Credito:</strong></td>
        	<td>
            	<cf_conlis
                    Campos="CBid,CBcodigo,CBdescripcion"
                    tabindex="6"
                    Desplegables="N,S,S"
                    Modificables="N,S,N"
                    Size="0,40,35"
                    Title="Lista Cuentas Bancarias"
                    Tabla="CuentasBancos c"
                    Columnas="CBid,CBcodigo,CBdescripcion"
                    Filtro="Ecodigo = #Session.Ecodigo# and CBesTCE=1 
                    		and (select count(1) from TEScuentasBancos where TESid=#session.Tesoreria.TESid# and CBid=c.CBid)=0
                    		order by CBcodigo,CBdescripcion"
                    Desplegar="CBcodigo,CBdescripcion"
                    Etiquetas="C&oacute;digo,Descripci&oacute;n"
                    filtrar_por="CBcodigo,CBdescripcion"
                    Formatos="S,S"
                    form="frmTESCB"
                    Align="left,left"
                    Asignar="CBid,CBcodigo,CBdescripcion"
                    Asignarformatos="I,S,S"
                    />
            </td>
            <td>
                    <cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" include="btnAgregar"  includevalues="Agregar" tabindex="1" >
            </td>
        </tr>
	</table>
	<table cellpadding="0" cellspacing="0" background="0" width="80%" align="center" border="0">
		<tr class="tituloListas">
            <td width="1"><strong>Emisor&nbsp;</strong></td>
			<td width="1"><strong>Activar&nbsp;</strong></td>
            <td width="1"><strong>Moneda&nbsp;</strong></td>
            <td><strong>Numero Tarjeta</strong></td>
            <td><strong>Empleado</strong></td>
		</tr>
		<tr>
        	<td colspan="5" style="font-size:2px">
            &nbsp;
            </td>
        </tr>
        <cfset LvarContador =0>
		<cfoutput query="Lista" group="Bdescripcion">
			<tr class="tituloListas">
				<td colspan="5">
                   #Bdescripcion#
                </td>
            </tr>
            <cfoutput>
				<cfif Lista.currentRow mod 2 EQ 0>
                    <cfset LvarClass = "listaPar">
                <cfelse>
                    <cfset LvarClass = "listaNon">
                </cfif>
    
                <tr class="#LvarClass#">
                	<td>&nbsp;</td>
                    <td align="center">
                        <input type="checkbox" name="TESCBactiva" value="#TESCBactiva#"  onchange="ActivarDesactivar(#LvarContador#);" <cfif TESCBactiva EQ 1>checked</cfif> tabindex="1">
                        <cfif CBid neq "">
                            <input type="hidden" name="CBidTemp" value="#CBid#">
                        </cfif>
                    </td>
                    <td>
                        #Miso4217#&nbsp;&nbsp;
                    </td>
                    <td>
                        #CBcodigo#&nbsp;&nbsp;
                    </td>
                    <td>
                        xxxxx
                    </td>
                </tr>
                <cfset LvarContador =LvarContador+1>
			</cfoutput>
		</cfoutput>
		<tr>
        	<td colspan="3">&nbsp;</td>
        </tr>
	</table>
</form>
<iframe id="ifrActiva" style="display:none"></iframe>
<script language="javascript" type="text/javascript">
	//document.frmTES.TESid.focus();
	
	function ActivarDesactivar(contador){
		
		var CBid = document.frmTESCB.CBidTemp[contador].value;
		if(document.frmTESCB.TESCBactiva[contador].checked)
			var Act= 1;
		else			 	
			var Act= 0;
		

		<cfoutput>
			document.getElementById("ifrActiva").src= "tarjetasCredito_sql.cfm?ActivarDesactivar=yes&CBid=" + CBid + "&Act=" + Act;
<!---			document.getElementById("ifrActiva").src= "tarjetasCredito_sql.cfm?SP=GENCF&tipoItem=S&Cid=" + document.formDet.Cid.value + "&SNid=" + SNid + "&CFid="+CFid;--->
		</cfoutput>
			//}
				
	}
	
</script>