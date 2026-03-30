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
        eo.EOplazo,
        case eo.EOplazo when 0 then 'Por entrega de informe /  Por adelanto y saldo'
            else convert(char,eo.EOplazo)
        end as Plazo,
        eo.EOlugarentrega,
	    m.Msimbolo,
        ' ' as Cfuncionales,
        ' ' as ESnumero,
        eo.EOhabiles
        
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
.bordes{	
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
	border-right:3px solid black;
	text-align:center;
}
</style>
<table width="80%"  align="center" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td class="Titulo" colspan="8">
    	Orden de Compra de Bienes y Servicios<br />
        	<strong class="Titulo" style="font-size:22px">OC-<cfoutput>#rsEncabezado.EOnumero#</cfoutput></strong>
    </td>
    <td align="right"><img src="/cfmx/sif/imagenes/Sutel.png" width="360" height="70" /></td>
  </tr>
	<cfif rsEncabezado.CMPnumero neq "">
      <tr>
        <td colspan="9" class="LetraPeq" align="right">Numero de Procedimiento:<cfoutput>&nbsp;<strong>#rsEncabezado.CMPnumero#</strong></cfoutput></td>
      </tr>
  </cfif>
</table>
<table width=" 85%"  align="center" border="0" cellpadding="0" cellspacing="0" >  
	<cfoutput query="rsEncabezado">
          <tr>
            <td  style="border-left:3px solid black; border-top:3px solid black;" colspan="5">Fecha:&nbsp;<strong>#LSdateFormat(EOfalta,"dd/mm/yy")#</strong></td>
            <td style="border-top:3px solid black;border-right:3px solid black;"colspan="4">Tel&eacute;fono:&nbsp;<strong>#SNtelefono#</strong></td>
          </tr>
          <tr>
            <td style="border-left:3px solid black;" colspan="5">Se&ntilde;or:&nbsp;<strong>#SNnombre#</strong></td>
            <td colspan="4" style="border-right:3px solid black;">Fax:&nbsp;<strong>#SNFax#</strong></td>
          </tr>
          <tr>
            <td style="border-left:3px solid black;" colspan="5">Correo electr&oacute;nico:&nbsp;<strong>#SNemail#</strong></td>
            <td colspan="4" style="border-right:3px solid black;">C&eacute;dula Jur&iacute;dica:&nbsp;<strong>#SNidentificacion#</strong></td>
          </tr>
          <tr><td style="border-left:3px solid black;border-right:3px solid black;" colspan="9">&nbsp;</td></tr>
          <tr>
            <td style="border-left:3px solid black; border-right:3px solid black;" colspan="9" align="center">Favor tramitar por cuenta de esta Instituci&oacute;n lo siguiente</td>
          </tr>
          <tr><td colspan="9" style="border-left:3px solid black; border-bottom:1px solid black;border-right:3px solid black;">&nbsp;</td></tr>
     </cfoutput> 
 <!--- Encabezado --->
  <tr style="background-color:#CCC;">
    <td style="border-left:3px solid black; border-bottom:1px solid black; font-weight:bold">Lin.</td>
    <td class="tdnormal" style="border-left:1px solid black;" width="15%">item</td>
    <td class="tdnormal" width="15%">Obs.</td>
    <td class="tdnormal">Cant.</td>
    <td class="tdnormal">P/Unitario</td>
    <td class="tdnormal">Importe</td>
    <td class="tdnormal">Impuesto</td>
    <td class="tdnormal">Monto Impuesto</td>
    <td style="border-bottom:1px solid black; border-right:3px solid black; font-weight:bold">Total</td> 
  </tr>
  <!--- Detalle --->
  <cfset LvarSubtotal = 0>
  <cfoutput query="rsDetalle">
      <tr>
        <td style="border-left:3px solid black; border-bottom:1px solid black;">&nbsp;#DOconsecutivo#</td>
        <td class="tdnormal2" style="border-left:1px solid black;">&nbsp;#ConceptoCompra#</td>
        <td class="tdnormal2" width="18%">&nbsp;#Obs#</td>
        <td class="tdnormal2">#DOcantidad#&nbsp;#Ucodigo#</td>
        <td class="tdnormal2">#rsEncabezado.Msimbolo#&nbsp;#DOpreciou#</td>
        <td class="tdnormal2">#rsEncabezado.Msimbolo#&nbsp;#Importe#</td>
        <td class="tdnormal2">#Idescripcion#-#Icodigo#</td>
        <td class="tdnormal2">#rsEncabezado.Msimbolo#&nbsp;#DOimpuestoCosto#</td>
        <td style="border-bottom:1px solid black; border-right:3px solid black;">#rsEncabezado.Msimbolo#&nbsp;#DOtotal#</td>
      </tr>
      <cfset LvarSubtotal = LvarSubtotal+DOtotal>
   </cfoutput>   
   <!--- Footer --->
   <tr>
  	<td colspan="7" style="border-bottom:1px solid black; border-left:3px solid black;">
        <p align="justify">&nbsp;
            Solicitado por <strong><cfoutput>#rsEncabezado.CFuncionales#</cfoutput></strong>, mediante las Solicitud de compra 
            <strong><cfoutput>#rsEncabezado.ESnumero#</cfoutput></strong>
        &nbsp;
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
			<tr><td style="border-bottom:1px solid black;border-right:3px solid black;"  align="center"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#LvarSubtotal#</cfoutput></td></tr>
            <tr><td class="tdnormalSub"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#rsEncabezado.Impuesto#</cfoutput></td></tr>
            <tr><td class="tdnormalSub"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#rsEncabezado.EOdesc#</cfoutput></td></tr>
            <tr><td class="tdnormalSub"><cfoutput>#rsEncabezado.Msimbolo#&nbsp;#rsEncabezado.EOtotal#</cfoutput></td></tr>
        </table>	
    </td>
  </tr>
   <!--- Footer2 --->
   <cfset LvarHabiles = "natural">    
    <cfif rsEncabezado.EOhabiles eq 1>
    	<cfset LvarHabiles = "habil">
    </cfif>
    <tr>
    	<td colspan="9" class="bordes"><strong>Plazo de Entrega:</strong>
			<cfoutput>
				<cfif rsEncabezado.EOdiasEntrega gt 0>
                    &nbsp;&nbsp;<cfoutput>#rsEncabezado.EOdiasEntrega#</cfoutput>
                    d&iacute;a<cfif rsEncabezado.EOdiasEntrega gt 1>s</cfif> #LvarHabiles#<cfif rsEncabezado.EOdiasEntrega gt 1>es</cfif>, 
                    luego de enviada la orden de compra por fax.
                </cfif>
            </cfoutput>
        </td>
    </tr>
   <tr>
    <td colspan="9" class="bordes"><strong>Forma de Pago:</strong>
			<cfoutput>
				<cfif rsEncabezado.Plazo gt 0>
                    &nbsp;&nbsp;<cfoutput>#rsEncabezado.Plazo#</cfoutput>
                    d&iacute;a<cfif rsEncabezado.Plazo gt 1>s</cfif> #LvarHabiles#<cfif rsEncabezado.Plazo gt 1>es</cfif>,
                    luego de enviada la orden de compra por fax.
                 <cfelseif rsEncabezado.EOplazo eq 0>
                        <cfoutput>#rsEncabezado.Plazo#</cfoutput>
                </cfif>
           </cfoutput> 
        </td>
	</tr>
    <tr>
        <td colspan="9" class="bordes"><strong>Lugar de entrega:</strong>
        &nbsp;&nbsp;<cfoutput>#rsEncabezado.EOlugarentrega#</cfoutput></td>
	</tr>
    <tr><td class="bordes" colspan="9">&nbsp;</td></tr>
    <tr><td class="bordes" colspan="9">&nbsp;</td></tr>
     <tr>
        <td colspan="3" align="center" style="border-left:3px solid black;">Proveedor</td>
        <td colspan="3" align="center" >Presupuesto</td>
        <td colspan="3" align="center" style="border-right: 3px solid black;">Autorizado por<br /><strong>SUPERINTENDENTE</strong></td>
	</tr>
    <tr><td colspan="9" class="bordes">&nbsp;</td></tr>
     <tr>
        <td colspan="9" class="bordes">
        	<p align="justify">
            	<strong>Nota importante:</strong>Para ejecutar el pago de su factura, se requiere que indique  en la misma, 
                el n&uacute;mero de cuenta corriente ( en colones o en d&oacute;lares) del Banco Nacional y en caso de no poseer, 
                debe anotar el n&uacute;mero de Cuenta Cliente (en colones o en d&oacute;lares) y el nombre del Banco correspondiente.
            </p>
        </td>
	</tr>
    <tr><td class="bordes" colspan="9">&nbsp;</td></tr>
    <tr>
        <td colspan="9" class="bordes">
        	<p align="justify">
            	<strong>Clausula Penal:</strong> Se aplicar&aacute; un rebajo de 0,1% del monto total adjudicado, 
                por cada d&iacute;a natural de atraso en la entrega, hasta alcanzar un m&aacute;ximo de 25%, 
                por causas no justificadas y no atribuibles a la Administraci&oacute;n, en cuyo caso se proceder&aacute; a 
                tramitar el proceso legal correspondiente.
            </p>
        </td>
	</tr>
    <tr><td style="border-bottom:3px solid black; border-left:3px solid black; border-right:3px solid black;" colspan="9">&nbsp;</td></tr>
</table>
<table width=" 85%" border="0" align="center">
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

