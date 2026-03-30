<cfset session.B2B = javacast("null","")>
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"/>
<cfset session.B2B.existe=0>
<cfset el_login=''>

<cfset usuario_existente = sec.getUsuarioByCodNoEmp(session.Usucodigo, 'SNegocios')>
<cfif usuario_existente.RecordCount eq 1>
	<cfquery name="rsSocio" datasource="#session.DSN#">
    	select SNnumero, SNcodigo, SNid, SNnombre, SNidentificacion, SNemail, SNtelefono, SNFax
        from SNegocios
        where Ecodigo = #session.Ecodigo#
        and SNcodigo = #usuario_existente.llave#
    </cfquery>

	<cfif rsSocio.recordcount eq 1>
		<cfset session.B2B.existe=1>
        <cfset session.B2B.SNnumero			= #rsSocio.SNnumero#>
        <cfset session.B2B.SNcodigo			= #rsSocio.SNcodigo#>
        <cfset session.B2B.SNid				= #rsSocio.SNid#>
        <cfset session.B2B.SNnombre			= #rsSocio.SNnombre#>
        <cfset session.B2B.SNidentificacion	= #rsSocio.SNidentificacion#>
        <cfset session.B2B.SNemail			= #rsSocio.SNemail#>
        <cfset session.B2B.SNtelefono		= #rsSocio.SNtelefono#>
        <cfset session.B2B.SNFax			= #rsSocio.SNFax#>
        
        <cfset session.B2B.SNids = -1>
        <cfquery name="rsSNcorporativo" datasource="#session.DSN#">
            select SNidCorporativo as socio, SNid
            from SNegocios
            where SNcodigo = #session.B2B.SNcodigo#
            and Ecodigo = #session.Ecodigo#
        </cfquery>
        <!--- <cfdump var="#rsSNcorporativo#"> --->
        <cfset session.B2B.SNids = ValueList(rsSNcorporativo.SNid)>
        <!--- <cfdump var="#LvarSNid#"> --->
        <cfif rsSNcorporativo.recordcount eq 1 and len(trim(rsSNcorporativo.socio)) eq 0>
            <!--- Puede ser que sea el corporativo, hay que buscar sus equivalentes --->
            <!--- Busca a sus equivalentes en cada empresa --->
            <cfquery name="rsCorporativos" datasource="#session.DSN#">
                select SNid as socio
                from SNegocios
                where SNidCorporativo in (#rsSNcorporativo.SNid#)
                union
                select #rsSNcorporativo.SNid#
                from dual
            </cfquery>
            <!--- <cfdump var="#rsCorporativos#">1 --->
            <cfset session.B2B.SNids = ValueList(rsCorporativos.socio)>
            <!--- <cfdump var="#LvarSNid#"> --->
        </cfif>
        <cfif rsSNcorporativo.recordcount eq 1 and len(trim(rsSNcorporativo.socio)) gt 0>
			<!--- Puede ser que sea el equivalente al corporativo pero como replica en otra empresa que no es la corporativa, hay que buscar 
            el corporativo y sus otros equivalentes --->
            <cfquery name="rsCorporativos2" datasource="#session.DSN#">
                select SNid as socio
                from SNegocios
                where SNidCorporativo in (#rsSNcorporativo.socio#)
                union
                select #rsSNcorporativo.socio#
                from dual
            </cfquery>
            <!--- <cfdump var="#rsCorporativos2#">2 --->
            <cfset session.B2B.SNids = ValueList(rsCorporativos2.socio)>
            <!--- <cfdump var="#LvarSNid#"> --->
        </cfif>
        
    <cfelse>
   		<cfset el_login='No es posible encontrar el Número de socio para el usuario #Session.Usulogin#'>
        <cfset session.B2B = javacast("null","")>
	</cfif>
<cfelse>
	<cfset el_login='El usuario de sistema #session.Usulogin# no está asociado a un socio de Negocios'>
</cfif>

<cf_templateheader title="Comercio Electrónico entre empresas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menú Principal">
	<br>

	<cfif session.B2B.existe eq 0 and len(trim(el_login)) gt 0>
		<table>
        	<tr>
            	<td>
                	#el_login#
                </td>
            </tr>
        </table>
    <cfelse>
        <cfsavecontent variable="RCimg">
            <img src="/cfmx/sif/B2B/imagenes/RegistroCotizacion.jpg" width="96" height="96" border="0">
        </cfsavecontent>
        <cfsavecontent variable="LPimg">
            <img src="/cfmx/sif/B2B/imagenes/ListaPrecios2.jpg" width="96" height="96" border="0">
        </cfsavecontent>
        <cfsavecontent variable="SaldosCimg">
            <img src="/cfmx/sif/B2B/imagenes/CuentasxCobrar1.jpg" width="96" height="96" border="0">
        </cfsavecontent>
        <cfsavecontent variable="SaldosPimg">
            <img src="/cfmx/sif/B2B/imagenes/Dinero3.jpeg" width="96" height="96" border="0">
        </cfsavecontent>
        <cfsavecontent variable="Ordenesimg">
            <img src="/cfmx/sif/B2B/imagenes/OrdenesCompra.jpg" width="96" height="96" border="0">
        </cfsavecontent>
        <cfsavecontent variable="CKimg">
            <img src="/cfmx/sif/B2B/imagenes/Cheques.jpg" width="96" height="96" border="0">
        </cfsavecontent>
    
        <table width="100%"  border="0" cellspacing="0" cellpadding="20">
	        <cfoutput>
                <tr >
                	<td colspan="3">
                    	<table cellspacing="0" cellpadding="5" width="100%" style="border-bottom:solid">
                        	<tr>
                            	<td><strong>Socio de Negocios:</strong> #session.B2B.SNnombre#</td>
                                <td><strong>Identificación:</strong> #session.B2B.SNidentificacion#</td>
                                <td >
                                    <strong>Número de Socio:</strong> #session.B2B.SNnumero#
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <strong>Correo:</strong> #session.B2B.SNemail#
                                </td>
                                <td>
                                    <strong>Teléfono:</strong> #session.B2B.SNtelefono#
                                </td>
                                <td>
                                    <strong>Fax:</strong> #session.B2B.SNFax#
                                </td>
                            </tr>	
                        </table>
                    </td>
                </tr>
            </cfoutput>
            <tr><hr />
                <td align="left" valign="middle" class="tituloSeccion"><cf_notas titulo="Registro de Cotizaciones" irA="/cfmx/sif/cm/proveedor/RegCotizaciones.cfm" link="#RCimg#" pageIndex="1" msg = "Usted puede revisar una lista de procesos de compra, registrar y enviar sus cotizaciones antes de que se venza el plazo de cotización." animar="true"><a href="/cfmx/sif/cm/proveedor/RegCotizaciones.cfm">Registro de Cotizaciones</a></td>
                <td align="left" valign="middle" class="tituloSeccion" colspan="1" rowspan="2">
                <fieldset style="border:1px solid ##CCCCCC"><legend><strong>Mi información</strong></legend><!--- Menu CxP, Consulta de documentos y Pagos Realizados --->
                    <table cellpadding="20">
                        <tr>
                            <!---<td align="left" valign="middle" class="tituloSeccion"> <cf_notas titulo="Cuentas por Cobrar" irA="/cfmx/sif/B2B/CxC/consultas/analisisSocio.cfm" link="#SaldosCimg#" pageIndex="2" msg = "Muestra su saldo registrado en el sistema." animar="true"><a href="/cfmx/sif/B2B/CxC/consultas/analisisSocio.cfm">Cuentas por Cobrar</a></td> --->
                            <!--- <td align="left" valign="middle" class="tituloSeccion"> <cf_notas titulo="Cuentas por Cobrar" irA="/cfmx/sif/cc/consultas/analisisSocio.cfm" link="#SaldosCimg#" pageIndex="2" msg = "Muestra su saldo registrado en el sistema." animar="true"><a href="/cfmx/sif/cc/consultas/analisisSocio.cfm">Cuentas por Cobrar</a></td>  --->
                            <td align="left" valign="middle" class="tituloSeccion"> <cf_notas titulo="Cuentas por Cobrar" irA="/cfmx/sif/B2B/CxC/consultas/analisisSocio.cfm" link="#SaldosCimg#" pageIndex="2" msg = "Muestra su saldo registrado en el sistema." animar="true"><a href="/cfmx/sif/B2B/CxC/consultas/analisisSocio.cfm">Cuentas por Cobrar</a></td>                             
                            <td align="left" valign="middle" class="tituloSeccion"> <cf_notas titulo="Ordenes de Compra"  irA="/cfmx/sif/B2B/CM/consultas/OrdenesCompra-lista.cfm" link="#Ordenesimg#" pageIndex="3" msg = "Muestra el detalle de las órdenes de compra donde usted fue escogido como proveedor." animar="true"><a href="/cfmx/sif/B2B/CM/consultas/OrdenesCompra-lista.cfm">Órdenes de Compra</a></td> 
                            
                        </tr>
                        <tr>
                            <td align="left" valign="middle" class="tituloSeccion"> <cf_notas titulo="Cuentas por Pagar" irA="/cfmx/sif/B2B/CxP/MenuCP.cfm" link="#SaldosPimg#" pageIndex="4" msg = "Muestra información de los pagos realizados." animar="true"><a href="/cfmx/sif/B2B/CxP/MenuCP.cfm">Cuentas por pagar</a></td>
                            <td align="left" valign="middle" class="tituloSeccion"> <cf_notas titulo="Consulta de Cheques" irA="/cfmx/sif/B2B/Tesoreria/Pagos/cheques/consultaCheques.cfm" link="#CKimg#" pageIndex="5" msg = "Le permite saber si un cheque esta impreso y listo para retirar." animar="true"><a href="/cfmx/sif/B2B/Tesoreria/Pagos/cheques/consultaCheques.cfm">Consulta de Cheques</a></td> 
                        </tr>
                    </table>
                </fieldset>
            </tr>
            <tr>
                <td align="left" valign="middle" class="tituloSeccion"><cf_notas titulo="Lista de Precios" irA="/cfmx/sif/cm/proveedor/ListaPrecios.cfm" link="#LPimg#" pageIndex="6" msg = "Mantenga actualizada la lista de precios del inventario de productos que usted maneja." animar="true"><a href="/cfmx/sif/cm/proveedor/ListaPrecios.cfm">Lista de Precios</a></td>
            </tr>
        </table>
    </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
