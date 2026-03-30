<form style="margin: 0" action="FAcancelacion.cfm" name="" method="post" id="">


<cfif (isdefined("Form.btnCancelar_Factura")) or isdefined("Form.Cancelar_Factura") > 
   <!---Obtenemos el CCTcodigo de las facturas seleccionadas--->
	<cfif (isdefined("Form.chk")) or isdefined("Form.Cancelar_Factura") >
			<cfset datos = ListToArray(Form.chk,",")>
	</cfif>
    <cfset motivo = "">
    <cfif isDefined("Form.MCanc")>
            <cfset motivo = "#Form.MCanc#">
    </cfif>
    <cfset datosFE = arrayToList(datos)>
    <!---Extraemos las facturas seleccionadas para obtener el codigo--->
    <cfset codigo = "">
    <cfloop array="#datos#" index="i">
        <cfset codigo = listAppend(codigo,replace(i,"FE-", "", "All"))>
    </cfloop>
   
        <cfset codigo = ListToArray(codigo,",")>
    <!--- Consulta para obtener el método de cancelación --->
    <cfquery name="rsParametros" datasource="#session.dsn#">
		select Pvalor from Parametros 
        where Pcodigo = 507		
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
	</cfquery>
    <cfset parametro = "#rsParametros.Pvalor#">

    <!--- Error si no existe ningun método de cancelación --->
    <cfif parametro eq "">
        <cfthrow message="No se ha seleccionado ningun método para cancelar. Favor de seleccionar un método">
    </cfif>
    <cfif parametro eq "Konesh">   
        <!---RFC DEL EMISOR--->
        <cfquery name="rsEmpresa" datasource="#session.dsn#">
            select  a.Eidentificacion 
            from Empresa a
                INNER JOIN Direcciones b
                    on a.id_direccion = b.id_direccion
            where a.Ecodigo = #session.Ecodigosdc#
        </cfquery>
        <cfset rfcEmisor = rsEmpresa.Eidentificacion>
        <!--- Invocamos el componente para cancelar la factura indicando que se trata de cancelación--->
        <cftransaction>
        <cfinvoke component="sif.Componentes.FA_CancelacionFactura"
							method="Cancelacion_Sust_Konesh"	
                            codigo = "#datosFE#"
                            RfcEmisor = "#rfcEmisor#"
                            Tipo = "Cancelacion"
                            Motivo = "#motivo#"
							Ecodigo = "#Session.Ecodigo#"
							usuario = "#Session.usuario#"
							USA_tran = "true"
						/> 
        </cftransaction>
 
    </cfif>
    <cfif parametro eq "CS">
        <cfdump  var="CSFacturación">
    </cfif>
    <cfif parametro eq "Manual">
        <cftransaction>
        <!--- Invocamos el componente para la cancelación manual --->
        <cfinvoke component="sif.Componentes.FA_CancelacionFactura"
	    						method="CancelacionFactura"	
                                Folios = "#datos#"
	    						Ecodigo = "#Session.Ecodigo#"
	    						usuario = "#Session.usuario#"
	    						USA_tran = "true"
	    					/> 
        </cftransaction>
        <cfdump  var="Factura Cancelada con éxito">
        <input name="Regresar" class="btn"  tabindex="1" type="submit" value="Regresar" >
    </cfif>                    
</cfif>
 </form>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
