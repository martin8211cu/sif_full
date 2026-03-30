<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<!---ID de la OC--->
<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden)) and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = url.EOidorden >
</cfif>
<cfif not isdefined("form.EOidorden") >
	<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
		<cfquery name="rsOrden" datasource="#session.DSN#">
			select EOidorden
			from EOrdenCM
			where Ecodigo =  #Session.Ecodigo# 
			and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
		</cfquery>
		<cfset form.EOidorden = rsOrden.EOidorden >
	</cfif>
</cfif>
<cfif not (isdefined("form.EOidorden") and len(trim(form.EOidorden)))>
	<cf_errorCode	code = "50272" msg = "No ha sido definida la Orden de Compra que desea imprimir.">
</cfif>
<!--- Empresa --->
<cfquery name="Empresa" datasource="asp">
    select e.Efax, e.Etelefono1, e.Etelefono2, e.Enumlicencia, d.direccion2
    from Empresa e
    	inner join Direcciones d 
        	on d.id_direccion = e.id_direccion
    where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsEmpresaLoc" datasource="#session.DSN#">
		select Mcodigo from Empresas where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
		select Msimbolo, Mnombre from Monedas where Mcodigo = #rsEmpresaLoc.Mcodigo#
</cfquery>
<!--- Encabezado--->
<cfquery name="rsEncabezado" datasource="#session.dsn#">
	select 
        eo.EOnumero,
        c.CMPnumero,
        eo.EOfalta,
        sn.SNnombre,
        sn.SNemail, 
        sn.SNtelefono, 
        sn.SNFax,
        sn.SNidentificacion,
        eo.Impuesto ,
        eo.EOdesc,
        eo.EOtotal,
        eo.EOdiasEntrega,
        case eo.EOplazo when 0 then 'Por entrega de informe /  Por adelanto y saldo'
            else convert(char,eo.EOplazo)
        end as EOplazo,
        eo.EOlugarentrega,
	    m.Msimbolo,
        ' ' as Cfuncionales,
        ' ' as ESnumero
        
    from EOrdenCM eo
    
        left join SNegocios sn
            on sn.SNcodigo = eo.SNcodigo
            and sn.Ecodigo = eo.Ecodigo
        
        left outer join CMProcesoCompra c
            on c.CMPid = eo.CMPid
            and c.Ecodigo = eo.Ecodigo

		inner join Monedas  m 
        	on m.Ecodigo = eo.Ecodigo 
        	and m.Mcodigo = eo.Mcodigo
        
    where eo.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and eo.EOidorden = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EOidorden#">
</cfquery>

<cfif rsEncabezado.recordCount EQ 0>
	<cf_errorCode	code = "50273" msg = "No se encontraron datos para el detalle de la Orden de Compra">
</cfif>

<!--- Detalles--->
<cfquery name="rsDetalle" datasource="#session.dsn#">
	select 
            do.DOconsecutivo,
            case ts.CMTStarticulo when 1 then a.Acodigo+'-'+do.DOdescripcion  
            else 
                case ts.CMTSservicio when 1 then c.Ccodigo+'-'+do.DOdescripcion 
                else 
                    case ts.CMTSactivofijo when 1 then do.DOdescripcion          
                    end     
                end
            end as ConceptoCompra,
            do.DOalterna +'<br>'+do.DOobservaciones as Obs,
            do.DOcantidad,
            do.Ucodigo,
            do.DOpreciou,
            (do.DOcantidad * do.DOpreciou) as importe,
            i.Idescripcion,
            i.Icodigo,
            do.DOimpuestoCF,
            do.DOimpuestoCosto,
            do.DOtotal
    
    from DOrdenCM do
        inner join EOrdenCM eo
            on eo.EOidorden = do.EOidorden
            and eo.Ecodigo = do.Ecodigo
            
        left join Conceptos c
            on c.Cid = do.Cid
            and c.Ecodigo = do.Ecodigo
        
        left join Articulos a
            on a.Aid= do.Aid
            and a.Ecodigo= do.Ecodigo
                       
        left join DSolicitudCompraCM ds
            on ds.ESidsolicitud = do.ESidsolicitud
            and ds.DSlinea = do.DSlinea
            and ds.Ecodigo = do.Ecodigo
        
        left join ESolicitudCompraCM es  
            on ds.ESidsolicitud = es.ESidsolicitud
            and es.ESidsolicitud = do.ESidsolicitud
        
        left join CMTiposSolicitud ts
            on ts.CMTScodigo = es.CMTScodigo 
            and ts.Ecodigo = es.Ecodigo
            
        inner join Impuestos i
            on i.Ecodigo = do.Ecodigo
            and i.Icodigo = do.Icodigo
        
    where eo.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and eo.EOidorden = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EOidorden#">
</cfquery>

<cfset LvarSC= "">
<cfset LvarCFuncional= "">
<cfloop query="rsEncabezado">
     <cfquery name="rsSCCfuncional" datasource="#session.dsn#">
     	select es.ESnumero, cf.CFdescripcion
        
        from  DOrdenCM do
	        inner join EOrdenCM eo
    	        on eo.EOidorden = do.EOidorden
        	    and eo.Ecodigo = do.Ecodigo
                
			left join DSolicitudCompraCM ds
            	on ds.ESidsolicitud = do.ESidsolicitud
            	and ds.DSlinea = do.DSlinea
            	and ds.Ecodigo = do.Ecodigo
        
        	left join ESolicitudCompraCM es  
            	on ds.ESidsolicitud = es.ESidsolicitud
           	 and es.ESidsolicitud = do.ESidsolicitud
             
             left outer join CFuncional cf
		           on do.CFid = cf.CFid
		where eo.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        		and eo.EOidorden = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.EOidorden#">
        group by es.ESnumero , cf.CFdescripcion
    </cfquery>
        <cfset LvarSC = "">
        <cfset LvarCFuncionales = "">
        <cfloop query="rsSCCfuncional">
             <cfif LvarSC neq "" and rsSCCfuncional.recordcount gt 0>
                    <cfset LvarSC = LvarSC&", "&rsSCCfuncional.ESnumero>
                    <cfset LvarCFuncionales = LvarCFuncionales&", "&rsSCCfuncional.CFdescripcion>
            <cfelse>
                <cfset LvarSC = LvarSC&rsSCCfuncional.ESnumero>
                 <cfset LvarCFuncionales = LvarCFuncionales&rsSCCfuncional.CFdescripcion>    
            </cfif> 
        </cfloop> 
        <cfset QuerySetCell(rsEncabezado, "ESnumero", LvarSC, currentRow)>
        <cfset QuerySetCell(rsEncabezado, "Cfuncionales", LvarCFuncionales, currentRow)>
        <cfset LvarSC="">
        <cfset LvarCFuncionales="">
</cfloop>


<cf_templatecss>
<style type="text/css">
.Titulo{
		font-family:Tahoma, Geneva, sans-serif;
		font-size:28px;
		text-align:center;
	}
.LetraOC{
		font-family:Tahoma, Geneva, sans-serif;
		font-size:25px;
		text-align:center;
		font-weight:200;
	}
.LetraPeq{
		font-size:12px;			
	}
	
.tablaborde1 {	
		border-top-width: 3px;
		border-top-style: solid;
		border-top-color: #000;
		border-left-width: 3px;
		border-left-style: solid;
		border-left-color: #000;
		border-right-width: 3px;
		border-right-style: solid;
		border-right-color: #000;
		
	}
.tabla2Encabezado {	
		border-bottom-width: 3px;
		border-bottom-style: solid;
		border-bottom-color: #000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000;
		border-left-width: 3px;
		border-left-style: solid;
		border-left-color: #000;
		border-right-width: 3px;
		border-right-style: solid;
		border-right-color: #000;
	}
.tdnormal {
	border-bottom:1px solid black;	
	border-right:1px solid black;
	font-weight:bold;
}
.tdnormal2 {
	border-bottom:1px solid black;	
	border-right:1px solid black;
	text-align:center;
}
.tdnormalSub{
	border-bottom:1px solid black;	
	font-weight:bold;
	text-align:center;
}
</style>
<table width="70%"  align="center" border="0" cellpadding="0" cellspacing="0">

  <tr>
    <td class="Titulo">
    	Orden de Compra de <br />Bienes y Servicios<br /><strong class="Titulo" style="font-size:22px">OC-<cfoutput>#rsEncabezado.EOnumero#</cfoutput></strong>

    </td>
    <td align="right"><img src="../../sif/imagenes/SUTEL.jpg" width="223" height="103" /></td>
  </tr>
  <tr>
    <td colspan="2" class="LetraPeq" align="right">Numero de Procedimiento:<cfoutput>#rsEncabezado.CMPnumero#</cfoutput></td>
  </tr>
</table>
<cfoutput query="rsEncabezado">
    <table width="70%"class="tablaborde1" align="center">
      <tr>
        <td colspan="5">Fecha:&nbsp;<strong>#EOfalta#</strong></td>
        <td colspan="4">Tel&eacute;fono:&nbsp;<strong>#SNtelefono#</strong></td>
      </tr>
      <tr>
        <td colspan="5">Se&ntilde;or:&nbsp;<strong>#SNnombre#</strong></td>
        <td colspan="4">Fax:&nbsp;<strong>#SNFax#</strong></td>
      </tr>
      <tr>
        <td colspan="5">Correo electr&oacute;nico:&nbsp;<strong>#SNemail#</strong></td>
        <td colspan="4">C&eacute;dula Jur&iacute;dica:&nbsp;<strong>#SNidentificacion#</strong></td>
      </tr>
      <tr><td colspan="9">&nbsp;</td></tr>
      <tr>
        <td colspan="9" align="center">Favor tramitar por cuenta de esta Instituci&oacute;n lo siguiente</td>
      </tr>
      <tr><td height="18" colspan="9">&nbsp;</td></tr>
    </table>
 </cfoutput> 
<table width="70%" class="tabla2Encabezado" cellpadding="0" cellspacing="0"  align="center">
 <!--- Encabezado --->
  <tr style="background-color:#CCC;">
    <td style="border-bottom:1px solid black; font-weight:bold">Lin.</td>
    <td class="tdnormal" style="border-left:1px solid black;">item</td>
    <td class="tdnormal" width="25%">Obs.</td>
    <td class="tdnormal">Cant.</td>
    <td class="tdnormal">P/Unitario</td>
    <td class="tdnormal">Importe</td>
    <td class="tdnormal">Impuesto</td>
    <td class="tdnormal">Monto Impuesto</td>
    <td style="border-bottom:1px solid black; font-weight:bold">Total</td> 
  </tr>
  <!--- Detalle --->
  <cfset LvarSubtotal = 0>
  <cfoutput query="rsDetalle">
      <tr>
        <td style="border-bottom:1px solid black;">#DOconsecutivo#</td>
        <td class="tdnormal2" style="border-left:1px solid black;">&nbsp;#ConceptoCompra#</td>
        <td class="tdnormal2" width="25%">#Obs#</td>
        <td class="tdnormal2">#DOcantidad#&nbsp;#Ucodigo#</td>
        <td class="tdnormal2">#rsEncabezado.Msimbolo#&nbsp;#DOpreciou#</td>
        <td class="tdnormal2">#rsEncabezado.Msimbolo#&nbsp;#Importe#</td>
        <td class="tdnormal2">#Idescripcion#-#Icodigo#</td>
        <td class="tdnormal2">#rsEncabezado.Msimbolo#&nbsp;#DOimpuestoCosto#</td>
        <td style="border-bottom:1px solid black;">#rsEncabezado.Msimbolo#&nbsp;#DOtotal#</td>
      </tr>
      <cfset LvarSubtotal = LvarSubtotal+DOtotal>
   </cfoutput>   
   <!--- Footer --->
   <tr>
  	<td colspan="7" style="border-bottom:1px solid black;">
        <p align="center">
            Solicitado por <strong><cfoutput>#rsEncabezado.CFuncionales#</cfoutput></strong>, Mediante las Solicitud de compra 
            <strong><cfoutput>#rsEncabezado.ESnumero#</cfoutput></strong>
        </p>
    </td>
    <td style="border-left:1px solid black;">
    	<table align="center" cellpadding="0" cellspacing="0" width="100%">
			<tr><td class="tdnormal">Sub Total</td></tr>
            <tr><td class="tdnormal">Impuestos</td></tr>
            <tr><td class="tdnormal">Descuentos</td></tr>
            <tr><td class="tdnormal">Total</td></tr>
        </table>	
    </td>
	<td>
    	<table align="center" cellpadding="0" cellspacing="0" width="100%">
			<tr><td style="border-bottom:1px solid black;"  align="center"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#LvarSubtotal#</cfoutput></td></tr>
            <tr><td class="tdnormalSub"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#rsEncabezado.Impuesto#</cfoutput></td></tr>
            <tr><td class="tdnormalSub"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#rsEncabezado.EOdesc#</cfoutput></td></tr>
            <tr><td class="tdnormalSub"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#rsEncabezado.EOtotal#</cfoutput></td></tr>
        </table>	
    </td>
  </tr>
   <!--- Footer2 --->
    <tr>
    	<td colspan="8"><strong>Plazo de Entrega:</strong>
		&nbsp;&nbsp;<cfoutput>#rsEncabezado.EOdiasEntrega#</cfoutput></td>
    </tr>
   <tr>
        <td colspan="8"><strong>Forma de Pago:</strong>
		&nbsp;&nbsp;<cfoutput>#rsEncabezado.EOplazo#</cfoutput></td>
	</tr>
    <tr>
        <td colspan="8"><strong>Lugar de entrega:</strong>
        &nbsp;&nbsp;<cfoutput>#rsEncabezado.EOlugarentrega#</cfoutput></td>
	</tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td colspan="3" align="center"></td>
        <td colspan="3" align="center"></td>
        <td colspan="3" align="center"></td>
	</tr>
     <tr>
        <td colspan="3" align="center">Proveedor</td>
        <td colspan="3" align="center">Presupuesto</td>
        <td colspan="3" align="center">Autorizado por<br /><strong>SUPERINTENDENTE</strong></td>
	</tr>
    <tr><td>&nbsp;</td></tr>
     <tr>
        <td colspan="9">
        	<p align="justify">
            	<strong>Nota importante:</strong>Para ejecutar el pago de su factura, se requiere que indique  en la misma, 
                el n&uacute;mero de cuenta corriente ( en colones o en d&oacute;lares) del Banco Nacional y en caso de no poseer, 
                debe anotar el n&uacute;mero de Cuenta Cliente (en colones o en d&oacute;lares) y el nombre del Banco correspondiente.
            </p>
        </td>
	</tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td colspan="9">
        	<p align="justify">
            	<strong>Clausula Penal:</strong> Se aplicar&aacute; un rebajo de 0,1% del monto total adjudicado, 
                por cada d&iacute;a natural de atraso en la entrega, hasta alcanzar un m&aacute;ximo de 25%, 
                por causas no justificadas y no atribuibles a la Administraci&oacute;n, en cuyo caso se proceder&aacute; a 
                tramitar el proceso legal correspondiente.
            </p>
        </td>
	</tr>
    <tr><td>&nbsp;</td></tr>
</table>
<table width="70%" border="0" align="center">
  <tr>
    <td colspan="3" align="center">C&eacute;dula Jur&iacute;dica</td>
    <td colspan="3" align="center">T&eacute;lefonos</td>
    <td colspan="3" align="center">Correo electr&oacute;nico</td>
  </tr>
  <tr>
    <td colspan="3" align="center"><cfoutput>#Empresa.Enumlicencia#</cfoutput></td>
    <td colspan="3" align="center"><cfoutput>#Empresa.Etelefono1 #&nbsp;/&nbsp;#Empresa.Etelefono2#</cfoutput></td>
    <td colspan="3" align="center"><cfoutput>#Empresa.direccion2#</cfoutput></td>
  </tr>
</table>

