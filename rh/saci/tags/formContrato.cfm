<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id del contrato --->
<cfparam	name="Attributes.login"			type="string"	default="">						<!--- login principal del contrato --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->

<cffunction name="rsLocalidad" output="true" returntype="query" access="public">
	<cfargument name="LCid" type="numeric" required="Yes" default="">
	<cfargument	name="Conexion"	type="string" required="no" default="#Session.DSN#">

	<cfquery name="rsLoc" datasource="#Arguments.Conexion#">
		Select lc.LCidPadre
			, lop.LCnombre as nombrePadre
			, lc.LCidHijo
			, lo.LCnombre as nombreHijo
			, lc.LCnivel
		from LocalidadCubo lc
			inner join Localidad lo
				on lo.LCid=lc.LCidHijo
			inner join Localidad lop
				on lop.LCid=lc.LCidPadre
		
		where lc.LCidHijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#">
	</cfquery>	
	
	<cfreturn rsLoc>
</cffunction>

<cfif Len(Trim(Attributes.id)) EQ 0>
	<cfthrow message="Error: se requiere enviar el atributo id obligatoriamente">
</cfif>

<!--- Empresa --->
<cfquery name="rsEmpresa" datasource="#Attributes.Conexion#">
	Select Edescripcion
	from Empresas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<!--- Vendedor --->
<cfquery name="rsVendedor" datasource="#Attributes.Conexion#">
	Select pr.Vid
		, v.Pquien
		, (p.Pnombre || ' ' || Papellido || ' ' || Papellido2) as nombreVend
		, v.AGid as codVend
	from ISBproducto pr
		left outer join ISBvendedor v
			on v.Vid=pr.Vid
		inner join ISBpersona p
			on p.Pquien=v.Pquien
	where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
</cfquery>

<!--- Cuenta --->
<cfquery name="rsCuenta" datasource="#Attributes.Conexion#">
	Select c.CTapertura, loc.Pdireccion, loc.Pbarrio, loc.LCid as LCid_cuenta, loc.CPid, CTtipoUso
	from ISBproducto p
		inner join ISBcuenta c
			on c.CTid=p.CTid
		left join ISBlocalizacion loc
			on c.CTid = loc.RefId 	
	where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
</cfquery>


<!--- Notificacion --->
<cfquery name="rsNotificacion" datasource="#Attributes.Conexion#">
	Select cn.CTcopiaModo 
		, cn.CTtipoEnvio
		, cn.CTcopiaDireccion
		, cn.CTapdoPostal
		, cn.CPid
		, cn.CTatencionEnvio
		, cn.CTdireccionEnvio
		, cn.LCid
	from ISBproducto p
		inner join ISBcuenta c
			on c.CTid=p.CTid
		inner join ISBcuentaNotifica cn
			on cn.CTid=c.CTid
	where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
</cfquery>



<!--- Forma de Cobro --->
<cfquery name="rsFormaCobro" datasource="#Attributes.Conexion#">
	Select cc.CTcobro	--	4=PagoCtaRacsa	2=Pago Aut. a Tarjeta 	1=Pago Aut. de Recibos
		, cc.CTbcoRef
		, cc.CTverificadorTC
		, cc.CTmesVencimiento
		, cc.CTanoVencimiento
		, ef.EFnombre
		, tar.MTnombre
		, cc.CTnombreTH
		, cc.CTapellido1TH
		, cc.CTapellido2TH
		, cc.CTcedulaTH
		, cc.PpaisTH		
		, case cc.CTtipoCtaBco
			when 'C' then 'Corriente'
			when 'A' then 'Ahorro'
		end CTtipoCtaBco		
	from ISBproducto p
		inner join ISBcuenta c
			on c.CTid=p.CTid
		left outer join ISBcuentaCobro cc
			on cc.CTid=c.CTid
		left outer join ISBentidadFinanciera ef
			on ef.EFid=cc.EFid
				and ef.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		left outer join ISBtarjeta tar
			on tar.MTid=cc.MTid
	where p.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
</cfquery>

<!--- Persona --->

<cfif rsCuenta.CTtipoUso NEQ 'A'>
	<cfquery name="rsPersona" datasource="#Attributes.Conexion#">
		Select	 tp.Pfisica
			, c.Pquien
			, per.Pid
			, per.PrazonSocial
			, per.AEactividad 
			, ae.AEnombre
			, per.Ptelefono1
			, per.Ptelefono2
			, per.Pfax
			, per.Pdireccion
			, per.LCid as LCid_persona
			, per.Papdo
			, per.CPid
			, per.Pnombre 
			, per.Papellido
			, per.Papellido2		
		from ISBproducto p
			inner join ISBcuenta c
				on c.CTid=p.CTid
			left outer join ISBpersona per
				on per.Pquien=c.Pquien
			left outer join ISBtipoPersona tp
				on tp.Ppersoneria=per.Ppersoneria
			left outer join ISBactividadEconomica ae
				on ae.AEactividad=per.AEactividad
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	</cfquery>
<cfelse>
	<cfquery name="rsPersona" datasource="#Attributes.Conexion#">
		Select	 tp.Pfisica
			, c.Pquien
			, per.Pid
			, per.PrazonSocial
			, per.AEactividad 
			, ae.AEnombre
			, loca.Ptelefono1
			, loca.Ptelefono2
			, loca.Pfax
			, loca.Pdireccion
			, loca.LCid as LCid_persona
			, loca.Papdo
			, loca.CPid
			, per.Pnombre 
			, per.Papellido
			, per.Papellido2		
		from ISBproducto p
			inner join ISBcuenta c
				on c.CTid=p.CTid
			left outer join ISBpersona per
				on per.Pquien=c.Pquien
			left outer join ISBagente ag
				on per.Pquien = ag.Pquien	
			left outer join ISBlocalizacion loca
				on ag.AGid = loca.RefId
				and loca.Ltipo = 'A'
			left outer join ISBtipoPersona tp
				on tp.Ppersoneria=per.Ppersoneria
			left outer join ISBactividadEconomica ae
				on ae.AEactividad=per.AEactividad
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	</cfquery>
</cfif>

<cfif isdefined('rsPersona') and rsPersona.recordCount GT 0>
	<!--- Persona Representante (Selecciona el primero) --->
	<cfquery name="rsPerRepre" datasource="#Attributes.Conexion#" maxrows="1">
		Select pr.Pcontacto
			, p.PrazonSocial
			, p.Pid
			, p.AEactividad
			, ae.AEnombre
			, loca.Ptelefono1
			, loca.Ptelefono2
			, loca.Pfax
			, loca.Pdireccion
			, loca.Papdo
			, loca.CPid
			, p.Pnombre 
			, p.Papellido
			, p.Papellido2
			, loca.LCid as LCid_representante
		from ISBpersonaRepresentante pr
			inner join ISBpersona p
				on p.Pquien=pr.Pcontacto
			left outer join ISBlocalizacion loca
				on 	pr.Rid = loca.RefId
				and loca.Ltipo = 'R'	
			left outer join ISBactividadEconomica ae
				on ae.AEactividad=p.AEactividad
		where pr.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPersona.Pquien#">
	</cfquery>
</cfif>

<!--- Paquete --->
<cfquery name="rsPaquete" datasource="#Attributes.Conexion#">
	Select pa.PQnombre
		, pa.PQdescripcion
		, pa.PQtarifaBasica
		, pa.MRidMayorista
		, mr.MRnombre
		, PQprecioExc
		, PQhorasBasica
	from ISBproducto p
		inner join ISBpaquete pa
			on pa.PQcodigo=p.PQcodigo
				and pa.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		left outer join ISBmayoristaRed mr
			on mr.MRidMayorista=pa.MRidMayorista
	where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
</cfquery>

<!--- Garantia --->
<cfquery name="rsGarantia" datasource="#Attributes.Conexion#">
	Select g.Gmonto
	from ISBgarantia g
		inner join ISBproducto p
			on p.Contratoid = g.Contratoid 
		inner join ISBpaquete pa
			on pa.PQcodigo=p.PQcodigo
				and pa.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	where g.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
</cfquery>

<!--- Login --->
<cfquery name="rsLogin" datasource="#Attributes.Conexion#">
	Select lo.LGlogin, lo.Snumero
	from ISBlogin lo
		inner join ISBproducto p
			on p.Contratoid = lo.Contratoid 
	where lo.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		<cfif isdefined('Attributes.login') and Attributes.login NEQ ''>
			and lo.LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.login#">
		</cfif>
</cfquery>

<!-- saved from url=(0022)http://internet.e-mail -->
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title></title>
</head>

<body>
<cfoutput>
  <table border="0" width="100%" cellspacing="0" cellpadding="0">
    <tr>
      <td width="100%">
        <table border="0" width="100%" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10%">
              <p align="center"> 
			  	<font face="Arial Narrow" size="2"> 
					<img id="img_MTlogo" width="64" height="47" src="<cfif Len(session.EcodigoSDC)>/cfmx/saci/utiles/logoEmpresa.cfm?EcodigoSDC=#URLEncodedFormat(session.EcodigoSDC)#<cfelse>about:blank</cfif>">				
				</font> 
			  </p>
			</td>
            <td width="90%" valign="top">
              <p align="center"> <b> <font face="Aero" size="4" color="##000080"> SOLICITUD PARA LA PRESTACION DEL SERVICIO </font> <font face="Aero" size="5" color="##000080"> </font> <font face="Aero" size="4" color="##000080"> INTERNET DE RADIOGRÁFICA COSTARRICENSE S.A. </font> </b> </p></td>
          </tr>
          <tr>
            <td width="10%">
              <p style="margin-left: 8" align="center"> </p></td>
            <td width="90%" valign="top">
              <p align="right"> </p></td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td width="100%">
        <table border="1" width="100%" cellspacing="0" cellpadding="0">
          <tr>
            <td width="25%">
              <p style="margin-left: 8"> <font face="Aero" size="1"> Empresa que tramita la solicitud: </font> </p></td>
            <td width="31%">
              	<p style="margin-left: 8"> 
					<font face="Aero" size="1"> 
						<cfif isdefined('rsEmpresa') and rsEmpresa.recordCount GT 0>
							#rsEmpresa.Edescripcion#
						</cfif>
					</font> 
				</p></td>
            <td width="19%">
              <p style="margin-left: 8"> <font face="Aero" size="1"> Fecha de firma: </font> </p></td>
            <td width="25%">
				  <p style="margin-left: 8"> 
					  <font face="Aero" size="1"> 
						  <soin> 
								<cfif isdefined('rsCuenta') and rsCuenta.recordCount GT 0>
									#LSDateFormat(rsCuenta.CTapertura,"dd/mm/yyyy")#
								</cfif>						  
						  <soin> 
					  </font> 
				  </p>
			  </td>
          </tr>
          <tr>
            <td width="25%">
              <p style="margin-left: 8"> <font face="Aero" size="1"> Funcionario que tramita: </font> </p></td>
            <td width="31%">
              	<p style="margin-left: 8"> 
					<font face="Aero" size="1"> 
						<soin> 
							<cfif isdefined('rsVendedor') and rsVendedor.recordCount GT 0>
								#rsVendedor.nombreVend#
							</cfif>
						<soin> 
					</font> 
				</p>
			</td>
            <td width="19%">
              <p style="margin-left: 8"> <font face="Aero" size="1"> Código de Vendedor: </font> </p></td>
            <td width="25%">
              	<p style="margin-left: 8"> 
					<font face="Aero" size="1"> 
						<soin> 
							<cfif isdefined('rsVendedor') and rsVendedor.recordCount GT 0>
								#rsVendedor.codVend#
							</cfif>					  
						<soin> 
					</font> 
				</p>
			</td>
          </tr>
          <tr>
            <td width="100%" colspan="4">&nbsp;</td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td width="100%">
        <table border="0" width="100%" cellspacing="0" cellpadding="0">
          <tr>
            <td width="50%" valign="top">
              <div align="left">
                <table border="0" width="100%" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="100%" valign="top">
                      <table border="1" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="100%" colspan="2" bgcolor="##006699">
                            <p style="margin-left: 3; margin-right: 3"> <b> <font face="Aero" size="1" color="##ffffff"> RADIOGRÁFICA COSTARRICENSE S. A. (RACSA) </font> </b> </p></td>
                        </tr>
                        <tr>
                          <td width="53%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Razón Social: Radiográfica Costarricense S.A. </font> </p></td>
                          <td width="47%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Cédula Jurídica: 3-101-009059 </font> </p></td>
                        </tr>
                        <tr>
                          <td width="53%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Apartado: 54-1000 San José, Costa Rica. </font> </p></td>
                          <td width="47%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Dirección: Calle 1, Avenida 5, San José. </font> </p></td>
                        </tr>
                        <tr>
                          <td width="53%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Correo elect: servicioacliente@racsa.co.cr </font> </p></td>
                          <td width="47%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Pág. web: http://www.racsa.co.cr </font> </p></td>
                        </tr>
                        <tr>
                          <td width="53%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Teléfono: (506) 287-0087 </font> </p></td>
                          <td width="47%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Fax: (506) 287-0508 </font> </p></td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="2">&nbsp;</td>
                        </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
					<cfset perJuridica = false>
					<cfif isdefined('rsPersona') and rsPersona.recordCount GT 0 and rsPersona.Pfisica EQ 0>
						<cfset perJuridica = true>
					</cfif>
					
                      <table border="1" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="100%" colspan="4" bgcolor="##006699">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1" color="##FFFFFF"> PRIMERA: CONDICIONES DEL SOLICITANTE Y DEL SERVICIO </font> </p></td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="4" bgcolor="##006699">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1" color="##FFFFFF"> PERSONA JURÍDICA </font> </p></td>
                        </tr>
                        <tr>
                          <td width="22%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Razón Social: </font> </p></td>
                          <td width="78%" colspan="3">
                            <p style="margin-left: 3; margin-right: 3"> 
								<font size="1" face="Aero"> 
									<soin> 
										<cfif perJuridica and rsPersona.PrazonSocial NEQ ''>
											#rsPersona.PrazonSocial#
										<cfelse>
											&nbsp;
										</cfif>
									<soin> 
								</font> 
							</p>
							</td>
                        </tr>
                        <tr>
                          <td width="22%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Cédula Jurídica: </font> </p></td>
                          <td width="23%">
                            <p style="margin-left: 3; margin-right: 3"> 
								<font size="1" face="Aero"> 
									<soin> 
										<cfif perJuridica and rsPersona.Pid NEQ ''>
											#rsPersona.Pid#
										<cfelse>
											&nbsp;
										</cfif>										
									<soin> 
								</font> 
							</p>
						  </td>
                          <td width="28%">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Actividad Económica: </font> </p></td>
                          <td width="27%">
								<p style="margin-left: 3; margin-right: 3"> 
									<font size="1" face="Aero"> 
										<soin> 
											<cfif perJuridica and rsPersona.AEnombre NEQ ''>
												#rsPersona.AEnombre#
											<cfelse>
												&nbsp;
											</cfif>
										<soin> 
									</font> 
								</p>
							</td>
                        </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
                      <div align="right">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="23%">
                              <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Teléfono (1): </font> </p></td>
                            <td width="15%">
                              <p style="margin-left: 3; margin-right: 3"> 
								  <font face="Aero" size="1"> 
									  <soin> 
										<cfif perJuridica and rsPersona.Ptelefono1 NEQ ''>
											#rsPersona.Ptelefono1#
										<cfelse>
											&nbsp;
										</cfif>									  
									  <soin> 
								  </font> 
							  </p>
							</td>
                            <td width="18%">
                              <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Teléfono (2): </font> </p></td>
                            <td width="16%">
                              <p style="margin-left: 3; margin-right: 3"> 
								  <font face="Aero" size="1"> 
									  <soin> 
										<cfif perJuridica and rsPersona.Ptelefono2 NEQ ''>
											#rsPersona.Ptelefono2#
										<cfelse>
											&nbsp;
										</cfif>														  
									  <soin> 
								  </font> 
							  </p>
							</td>
                            <td width="11%">
                              <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Fax: </font> </p></td>
                            <td width="23%">
                              <p style="margin-left: 3; margin-right: 3"> 
								  <font face="Aero" size="1"> 
									  <soin> 
										<cfif perJuridica and rsPersona.Pfax NEQ ''>
											#rsPersona.Pfax#
										<cfelse>
											&nbsp;
										</cfif>													  
									  <soin> 
								  </font> 
							  </p>
							</td>
                          </tr>							  
                          <tr>
                            <td width="23%">
                              <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> N° Apartado: </font> </p></td>
                            <td width="33%" colspan="2">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									<cfif perJuridica and rsPersona.Papdo NEQ ''>
										#rsPersona.Papdo#
									<cfelse>
										&nbsp;
									</cfif>									  
								  </font>
							  </p>
							</td>
                            <td width="16%">
                              <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Zona Postal: </font> </p></td>
                            <td width="34%" colspan="2">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									<cfif perJuridica and rsPersona.CPid NEQ ''>
										#rsPersona.CPid#
									<cfelse>
										&nbsp;
									</cfif>		
								  </font> 
							  </p>
							</td>
                          </tr>
                          <tr>
                            <td width="100%" colspan="6">
								<cfset rsLocalidPers = ''>
								<cfset vProvPers = ''>
								<cfset vCantonPers = ''>
								<cfset vDistrPers = ''>							
								<cfif perJuridica and rsPersona.LCid_persona NEQ ''>
									<cfset rsLocalidPers = rsLocalidad(rsPersona.LCid_persona)>
									
									<cfif rsLocalidPers.recordCount GT 0>
										<cfloop query="rsLocalidPers">
											<cfif rsLocalidPers.LCnivel EQ 1>	<!--- Canton --->
												<cfset vCantonPers = rsLocalidPers.nombrePadre>											
											<cfelseif rsLocalidPers.LCnivel EQ 2>	<!--- Provincia --->
												<cfset vProvPers = rsLocalidPers.nombrePadre>
											</cfif>
											<cfset vDistrPers = rsLocalidPers.nombreHijo>
										</cfloop>
									</cfif>
								</cfif>										
                              <div align="right">
                                <table border="0" width="100%" cellspacing="0" cellpadding="0">
                                  <tr>
                                    <td width="13%">
                                      <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1"><b>Provincia:</b></font></p></td>
                                    <td width="12%">
                                      <p style="margin-left: 3; margin-right: 3" align="center">
										  <font face="Aero" size="2">
											  <soin>
												  #vProvPers#
											  <soin>
										  </font>
									  </p>
									  </td>
                                    <td width="11%">
                                      <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1"><b>Cantón:</b></font></p></td>
                                    <td width="26%">
                                      <p style="margin-left: 3; margin-right: 3">
										  <font face="Aero" size="2">
											  <soin>
												  #vCantonPers#
											  <soin>
										  </font>
									  </p>
									  </td>
                                    <td width="11%">
                                      <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1"><b>Distrito:</b></font></p></td>
                                    <td width="27%">
                                      <p style="margin-left: 3; margin-right: 3">
										  <font face="Aero" size="2">
											  <soin>
											 	 #vDistrPers#
											  <soin>
										  </font>
									  </p>
									</td>
                                  </tr>
                                </table>
                            </div></td>
                          </tr>	  
                          <tr>
                            <td width="23%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Dirección Exacta:</font></p></td>
                            <td width="82%" colspan="5">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									  <soin>
										<cfif perJuridica and rsPersona.Pdireccion NEQ ''>
											#rsPersona.Pdireccion#
										<cfelse>
											&nbsp;
										</cfif>											  
									  <soin>
								  </font>
							  </p>
							</td>
                          </tr>
                         <!--- <tr>
                            <td width="23%"> <font face="Aero" size="1">Apoderado:</font></td>
                            <td width="81%" colspan="5">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									  <soin>
										<cfif perJuridica and rsPersona.Pnombre NEQ ''>
											#rsPersona.Pnombre# #rsPersona.Papellido# #rsPersona.Papellido2#
										<cfelse>
											&nbsp;
										</cfif>													  
									  <soin>
								  </font>
							  </p>
							</td>
                          </tr>
                          <tr>--->
                            <td width="104%" colspan="6">&nbsp;</td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
                      <table border="1" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="100%" bgcolor="##006699" colspan="2">
                            <p style="margin-left: 3; margin-right: 3"><font color="##FFFFFF" size="1" face="Aero">PERSONA FÍSICA O REPRESENTANTE LEGAL</font></p></td>
                        </tr>
                        <tr>
                          <td width="21%">
                            <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Nombre Cuenta:</font></p></td>
                          <td width="79%">
                            <p style="margin-left: 3; margin-right: 3">
								<font face="Aero" size="1">
									<soin>
										<cfif perJuridica>
											<cfif isdefined('rsPerRepre')>
												#rsPerRepre.Pnombre# #rsPerRepre.Papellido# #rsPerRepre.Papellido2#
											<cfelse>
												&nbsp;
											</cfif>
										<cfelse>
											<cfif isdefined('rsPersona')>
												#rsPersona.Pnombre# #rsPersona.Papellido# #rsPersona.Papellido2#
											<cfelse>
												&nbsp;
											</cfif>
										</cfif> 
									<soin>
								</font>
							</p>
						  </td>
                        </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
                      <div align="right">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="20%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Cédula o Pasaporte:</font></p></td>
                            <td width="43%">
                              	<p style="margin-left: 3; margin-right: 3">
							  		<font face="Aero" size="1">
							  			<soin>
											<cfif perJuridica>
												<cfif isdefined('rsPerRepre') and rsPerRepre.Pid NEQ ''>
													#rsPerRepre.Pid#
												<cfelse>
													&nbsp;
												</cfif>
											<cfelse>
												<cfif isdefined('rsPersona') and rsPersona.Pid NEQ ''>
													#rsPersona.Pid#
												<cfelse>
													&nbsp;
												</cfif>
											</cfif> 							  
							  			<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="20%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Actividad Económica:</font></p></td>
                            <td width="43%">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									  <soin>
											<cfif perJuridica>
												<cfif isdefined('rsPerRepre') and rsPerRepre.AEnombre NEQ ''>
													#rsPerRepre.AEnombre#
												<cfelse>
													&nbsp;
												</cfif>
											<cfelse>
												<cfif isdefined('rsPersona') and rsPersona.AEnombre NEQ ''>
													#rsPersona.AEnombre#
												<cfelse>
													&nbsp;
												</cfif>
											</cfif> 										  
									  <soin>
								  </font>
							  </p>
							</td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
                      <div align="left">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="19%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Teléfono (1):</font></p></td>
                            <td width="16%">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									  <soin>
											<cfif perJuridica>
												<cfif isdefined('rsPerRepre') and rsPerRepre.Ptelefono1 NEQ ''>
													#rsPerRepre.Ptelefono1#
												<cfelse>
													&nbsp;
												</cfif>
											<cfelse>
												<cfif isdefined('rsPersona') and rsPersona.Ptelefono1 NEQ ''>
													#rsPersona.Ptelefono1#
												<cfelse>
													&nbsp;
												</cfif>
											</cfif> 	
									  <soin>
								  </font>
							  </p>
							</td>
                            <td width="18%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Teléfono (2):</font></p></td>
                            <td width="18%">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									  <soin>
											<cfif perJuridica>
												<cfif isdefined('rsPerRepre') and rsPerRepre.Ptelefono2 NEQ ''>
													#rsPerRepre.Ptelefono2#
												<cfelse>
													&nbsp;
												</cfif>
											<cfelse>
												<cfif isdefined('rsPersona') and rsPersona.Ptelefono2 NEQ ''>
													#rsPersona.Ptelefono2#
												<cfelse>
													&nbsp;
												</cfif>
											</cfif> 										  
									  <soin>
								  </font>
							  </p>
							</td>
                            <td width="9%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Fax:</font></p></td>
                            <td width="22%">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
									  <soin>
											<cfif perJuridica>
												<cfif isdefined('rsPerRepre') and rsPerRepre.Pfax NEQ ''>
													#rsPerRepre.Pfax#
												<cfelse>
													&nbsp;
												</cfif>
											<cfelse>
												<cfif isdefined('rsPersona') and rsPersona.Pfax NEQ ''>
													#rsPersona.Pfax#
												<cfelse>
													&nbsp;
												</cfif>
											</cfif> 			
									  <soin>
								  </font>
							  </p>
							</td>
                          </tr>
                          <tr>
                            <td width="19%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">N<font lang="JA">°</font>Apartado:</font></p></td>
                            <td width="34%" colspan="2">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
										<cfif perJuridica>
											<cfif isdefined('rsPerRepre') and rsPerRepre.Papdo NEQ ''>
												#rsPerRepre.Papdo#
											<cfelse>
												&nbsp;
											</cfif>
										<cfelse>
											<cfif isdefined('rsPersona') and rsPersona.Papdo NEQ ''>
												#rsPersona.Papdo#
											<cfelse>
												&nbsp;
											</cfif>
										</cfif> 
								  </font>
							  </p>
							</td>
                            <td width="18%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Zona Postal:</font></p></td>
                            <td width="31%" colspan="2">
                              <p style="margin-left: 3; margin-right: 3">
								  <font face="Aero" size="1">
										<cfif perJuridica>
											<cfif isdefined('rsPerRepre') and rsPerRepre.CPid NEQ ''>
												#rsPerRepre.CPid#
											<cfelse>
												&nbsp;
											</cfif>
										<cfelse>
											<cfif isdefined('rsCuenta') and rsCuenta.CPid NEQ ''>
												#rsCuenta.CPid#
											<cfelse>
												&nbsp;
											</cfif>
										</cfif> 								  
								  </font>
							  </p>
							</td>
                          </tr>
                          <tr>
                            <td width="102%" colspan="6">
								<cfset rsLocalidPersRepre = ''>
								<cfset vProvPR = ''>
								<cfset vCantonPR = ''>
								<cfset vDistrPR = ''>				
								<cfif perJuridica>
									<cfif isdefined('rsPerRepre') and rsPerRepre.LCid_representante NEQ ''>
										<cfset rsLocalidPersRepre = rsLocalidad(rsPerRepre.LCid_representante)>
									</cfif>
								<cfelse>
									<cfif isdefined('rsCuenta') and rsCuenta.LCid_cuenta NEQ ''>
										<cfset rsLocalidPersRepre = rsLocalidad(rsCuenta.LCid_cuenta)>
									</cfif>
								</cfif>	
								
								<cfif isdefined('rsLocalidPersRepre.RecordCount') and rsLocalidPersRepre.recordCount GT 0>
									<cfloop query="rsLocalidPersRepre">
										<cfif rsLocalidPersRepre.LCnivel EQ 1>	<!--- Canton --->
											<cfset vCantonPR = rsLocalidPersRepre.nombrePadre>											
										<cfelseif rsLocalidPersRepre.LCnivel EQ 2>	<!--- Provincia --->
											<cfset vProvPR = rsLocalidPersRepre.nombrePadre>
										</cfif>
										<cfset vDistrPR = rsLocalidPersRepre.nombreHijo>	<!--- Distrito --->
									</cfloop>
								</cfif>								
                              <table border="0" width="100%" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td width="15%">
                                    <p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero"><b>Provincia:</b></font></p></td>
                                  <td width="13%">
                                    <p style="margin-left: 3; margin-right: 3">
										<font size="1" face="Aero">
											<soin>
												#vProvPR#
											<soin>
										</font>
									</p>
								  </td>
                                  <td width="12%">
                                    <p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero"><b>Cantón:</b></font></p></td>
                                  <td width="20%">
                                    <p style="margin-left: 3; margin-right: 3">
										<font face="Aero" size="1">
											<soin>
												#vCantonPR#
											<soin>
										</font>
									</p>
								  </td>
                                  <td width="13%">
                                    <p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero"><b>Distrito:</b></font></p></td>
                                  <td width="27%">
                                    <p style="margin-left: 3; margin-right: 3">
										<font face="Aero" size="1">
											<soin>
												#vDistrPR#
											<soin>
										</font>
									</p>
								  </td>
                                </tr>
                                <tr>
                                  <td width="100%" colspan="6">
                                    <table border="1" width="100%" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="26%">
                                          <p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Dirección Exacta:</font></p></td>
                                        <td width="74%">
                                          <p style="margin-left: 3; margin-right: 3">
										  	<font face="Aero" size="1">
										  		<soin>
													<cfif perJuridica>
														<cfif isdefined('rsPerRepre') and rsPerRepre.Pdireccion NEQ ''>
															#rsPerRepre.Pdireccion#
														<cfelse>
															&nbsp;
														</cfif>
													<cfelse>
														<cfif isdefined('rsPersona') and rsPersona.Pdireccion NEQ ''>
															#rsCuenta.Pdireccion#
														<cfelse>
															&nbsp;
														</cfif>
													</cfif> 	
												<soin>
											</font>
										  </p>
										</td>
                                      </tr>
                                      <tr>
                                        <td width="100%" colspan="2">&nbsp;</td>
                                      </tr>
                                  </table></td>
                                </tr>
                            </table></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
                      <div align="left">
                        <table border="0" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="100%" bgcolor="##006699">
                              <p style="margin-left: 3; margin-right: 3"><font color="##FFFFFF" size="1" face="Aero">CARACTERÍSTICAS DEL SERVICIO</font></p></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
                      <div align="left">
                        <table border="1" width="101%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Modalidad del Servicio</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif isdefined('rsPaquete') and rsPaquete.recordCount GT 0 and rsPaquete.MRidMayorista NEQ ''>
												#rsPaquete.MRnombre#
											<cfelse>
												&nbsp;
											</cfif>
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Nombre del Paquete</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif isdefined('rsPaquete') and rsPaquete.recordCount GT 0>
												#rsPaquete.PQdescripcion#
											<cfelse>
												&nbsp;
											</cfif>
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Tarifa Básica</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif isdefined('rsPaquete') and rsPaquete.recordCount GT 0>
												#LSCurrencyFormat(rsPaquete.PQtarifaBasica, 'none')#
											<cfelse>
												&nbsp;
											</cfif>										
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Depósito de Garantía</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%">
								<p style="margin-left: 3; margin-right: 3">
									<font size="1" face="Aero">
										<soin>
											<cfif isdefined('rsGarantia') and rsGarantia.recordCount GT 0>
												#LSCurrencyFormat(rsGarantia.Gmonto, 'none')#
											<cfelse>
												&nbsp;
											</cfif>
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Derecho de Horas Mensuales</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif isdefined('rsPaquete') and rsPaquete.recordCount GT 0>
												#LSCurrencyFormat(rsPaquete.PQhorasBasica, 'none')#
											<cfelse>
												&nbsp;
											</cfif>								
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Costo por Hora Adicional</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif isdefined('rsPaquete') and rsPaquete.recordCount GT 0>
												#LSCurrencyFormat(rsPaquete.PQprecioExc, 'none')#
											<cfelse>
												&nbsp;
											</cfif>			
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Cantidad de Correos Electrónicos</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="43%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">N<font face="Arial Unicode MS" lang="JA" size="1">°</font> de Suscriptor (Cable Modem)</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Fecha de Instalación (Cable Modem)</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">N° Máximo de Terminales</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">N° de Direcciones IP</font></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Modalidad de Pago</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Condición de retiro anticipado</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="64%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="106%" colspan="3"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="106%" colspan="3"><font face="Aero" size="1">&nbsp;</font></td>
                          </tr>
                          <tr>
                            <td width="106%" colspan="3"><font face="Aero" size="1">&nbsp;</font></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%" valign="top">
                      <div align="left">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="100%" colspan="6">
                              <p style="margin-left: 3; margin-right: 3"> <b> <font size="1" face="Aero"> El login o nombre de usuario debe contener mínimo 6 y máximo 16 caracteres (únicamente letras y números). </font> </b> </p></td>
                          </tr>
                          <tr>
                            <td width="100%" colspan="6" bgcolor="##006699">
                              <p style="margin-left: 3; margin-right: 3"><b><font color="##ffffff" size="1" face="Aero">Login Principal:</font></b></td>
                          </tr>
                          <tr>
                            <td width="12%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Login 1º</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="36%">
								<p style="margin-left: 3; margin-right: 3" align="center">
									<font face="Aero" size="1">
										<soin>
											<cfif isdefined('rsLogin') and rsLogin.recordCount GT 0>
												#rsLogin.LGlogin#
											<cfelse>
												&nbsp;
											</cfif>										
										<soin>
									</font>
								</p>
							</td>
                            <td width="14%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Login 2º</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="12%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Login 3º</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="36%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                            <td width="14%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Nº Sobre</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="43%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
									<soin>
											<cfif isdefined('rsLogin') and rsLogin.recordCount GT 0>
												#rsLogin.Snumero#
											<cfelse>
												&nbsp;
											</cfif>										
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="100%" colspan="6" bgcolor="##006699"><p style="margin-left: 3; margin-right: 3"><b><font color="##ffffff" size="1" face="Aero">Correo Adicional:</font></b></p></td>
                          </tr>
                          <tr>
                            <td width="12%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Login 1º</font></p></td>
                            <td width="3%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="36%"><p style="margin-left: 3; margin-right: 3" align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                            <td width="14%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Login 2º</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3" align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="12%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Login 3º</font></p></td>
                            <td width="3%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="36%"><p style="margin-left: 3; margin-right: 3" align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                            <td width="14%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Nº Sobre</font></p></td>
                            <td width="3%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">:</font></p></td>
                            <td width="43%"><p style="margin-left: 3; margin-right: 3" align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="111%" colspan="6" bgcolor="##006699"><font face="Aero" size="1" color="##FFFFFF">Login Conmutado:</font>
                                <p></p></td>
                          </tr>
                          <tr>
                            <td width="12%"><font face="Aero" size="1">Login 1º</font></td>
                            <td width="3%" align="center"><font face="Aero" size="1">:</font>
                                <p></p></td>
                            <td width="36%"><p align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                            <td width="14%"><font face="Aero" size="1">Login 2º</font></td>
                            <td width="3%" align="center"><font face="Aero" size="1">:</font></td>
                            <td width="43%"><p align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                          <tr>
                            <td width="12%"><font face="Aero" size="1">Login 3º</font></td>
                            <td width="3%" align="center"><font face="Aero" size="1">:</font></td>
                            <td width="36%"><p align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                            <td width="14%"><font face="Aero" size="1">Nº Sobre</font></td>
                            <td width="3%" align="center"><font face="Aero" size="1">:</font></td>
                            <td width="43%"><p align="center"><font face="Aero" size="1">&nbsp;</font></p></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                </table>
            </div></td>
            <td width="50%" valign="top">
              <div align="right">
                <table border="0" width="100%" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="100%">
                      <table border="1" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="100%" colspan="4" bgcolor="##006699">
                            <p style="margin-left: 3; margin-right: 3"> <font color="##FFFFFF" size="1" face="Aero"> ENVIO DE FACTURAS Y NOTIFICACIONES </font> </p></td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="4">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> 1)Por este medio el solicitante autoriza a RACSA el envío de la factura e información a la siguiente casilla de correo electrónico: </font> </p></td>
                        </tr>
                        <tr>
							<td width="100%" colspan="4">
								<p style="margin-left: 3; margin-right: 3" align="center"> 
									<font size="1" face="Aero"> 
										<soin> 
											<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
												<cfif rsNotificacion.CTcopiaModo EQ 'E'><!--- Email --->
													#rsNotificacion.CTcopiaDireccion#
												</cfif>
											</cfif>	
										<soin> 
									</font> 
								</p>
							</td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="4">
                            <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> 2)En caso de que el cliente no desee el envío a la casilla de correo electrónico que se indica en el punto 1), la factura será enviada a: </font> </p></td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="4">
                            <table border="0" width="106%" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="47%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Dirección Física anteriormente indicada:</font></p></td>
                                <td width="4%"><p style="margin-left: 3; margin-right: 3" align="right"><font face="Aero" size="1">SI</font></p></td>
                                <td width="6%">
									<p style="margin-left: 3; margin-right: 3" align="center">
										<font face="Aero" size="1">
											<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
												<cfif rsNotificacion.CTtipoEnvio EQ '2'><!--- Fisica --->
													X
												</cfif>
											</cfif>											
										</font>
									</p>
								</td>
                                <td width="16%"><p style="margin-left: 3; margin-right: 3" align="right"><font face="Aero" size="1">NO</font></p></td>
                                <td width="5%">
									<p style="margin-left: 3; margin-right: 3" align="left">
										<font face="Aero" size="1">
											<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
												<cfif rsNotificacion.CTtipoEnvio EQ '1'><!--- Apdo Postal --->
													X
												</cfif>
											</cfif>										
										</font>
									</p>
								</td>
                                <td width="28%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">&nbsp;</font></p></td>
                              </tr>
                          </table></td>
                        </tr>
                        <tr>
                          	<td width="25%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">N<font face="Arial Unicode MS" lang="JA" size="1">°</font>Apartado:</font></p></td>
                          	<td width="28%">
								<p style="margin-left: 3; margin-right: 3" align="center">
									<font size="1" face="Aero">
										<soin>
											<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
												<cfif rsNotificacion.CTtipoEnvio EQ '1' and rsNotificacion.CTapdoPostal NEQ ''>
													#rsNotificacion.CTapdoPostal#
												<cfelse>
													&nbsp;
												</cfif>
											</cfif>												
										<soin>
									</font>
								</p>
							</td>
                          	<td width="16%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Zona Postal:</font></p></td>
                          	<td width="31%">
								<p style="margin-left: 3; margin-right: 3" align="center">
									<font size="1" face="Aero">
										<soin>
											<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
												<cfif rsNotificacion.CTtipoEnvio EQ '1' and rsNotificacion.CPid NEQ ''>
													#rsNotificacion.CPid#
												<cfelse>
													&nbsp;
												</cfif>
											</cfif>												
										<soin>
									</font>
								</p>
							</td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="4" bgcolor="##FFFFFF">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="4" bgcolor="##006699"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1" color="##FFFFFF">Otra Dirección Física:</font></p></td>
                        </tr>
                        <tr>
                          <td width="25%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Con Atención a:</font></p></td>
                          <td width="75%" colspan="3">
						  	<p style="margin-left: 3; margin-right: 3">
								<font face="Aero" size="1">
									<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
										<cfif rsNotificacion.CTtipoEnvio EQ '1' and rsNotificacion.CTatencionEnvio NEQ ''>
											#rsNotificacion.CTatencionEnvio#
										<cfelse>
											&nbsp;
										</cfif>
									</cfif>						  
						  		</font>
						  	</p>
						  </td>
                        </tr>
                        <tr>
                          <td width="100%" colspan="4">
							<cfset rsLocalid = ''>
							<cfset vProv = ''>
							<cfset vCanton = ''>
							<cfset vDistr = ''>							
							<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
								<cfif rsNotificacion.CTtipoEnvio EQ '2' and rsNotificacion.LCid NEQ ''>
									<cfset rsLocalid = rsLocalidad(rsNotificacion.LCid)>
									<cfif rsLocalid.recordCount GT 0>
										<cfloop query="rsLocalid">
											<cfif rsLocalid.LCnivel EQ 1>	<!--- Canton --->
												<cfset vCanton = rsLocalid.nombrePadre>											
											<cfelseif rsLocalid.LCnivel EQ 2>	<!--- Provincia --->
												<cfset vProv = rsLocalid.nombrePadre>
											</cfif>
											<cfset vDistr = rsLocalid.nombreHijo>
										</cfloop>
									</cfif>
								</cfif>
							</cfif>						
                            <table border="0" width="100%" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="16%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero"><strong>Provincia</strong>:</font></p></td>
                                <td width="16%">
									<p style="margin-left: 3; margin-right: 3">
										<font size="2" face="Aero">
											<cfif vProv NEQ ''>
												#vProv#
											<cfelse>
												&nbsp;
											</cfif>
										</font>
									</p>
								</td>
                                <td width="17%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero"><strong>Cantón</strong>:</font></p></td>
                                <td width="17%">
									<p style="margin-left: 3; margin-right: 3">
										<font size="2" face="Aero">
											<cfif vCanton NEQ ''>
												#vCanton#
											<cfelse>
												&nbsp;
											</cfif>								
										</font>
									</p>
								</td>
                                <td width="17%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero"><strong>Distrito</strong>:</font></p></td>
                                <td width="17%">
									<p style="margin-left: 3; margin-right: 3">
										<font size="2" face="Aero">
											<cfif vDistr NEQ ''>
												#vDistr#
											<cfelse>
												&nbsp;
											</cfif>									
										</font>											
									</p>
								</td>
                              </tr>
                              <tr>
                                <td width="100%" colspan="6">
                                  <table border="1" width="100%" cellspacing="0" cellpadding="0">
                                    <tr>
                                      	<td width="26%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Dirección Exacta:</font></p></td>
                                      	<td width="74%">
											<p style="margin-left: 3; margin-right: 3">
												<font size="1" face="Aero">
													<soin>
														<cfif isdefined('rsNotificacion') and rsNotificacion.recordCount GT 0>
															<cfif rsNotificacion.CTtipoEnvio EQ '2' and rsNotificacion.CTdireccionEnvio NEQ ''>
																#rsNotificacion.CTdireccionEnvio#
															<cfelse>
																&nbsp;
															</cfif>
														</cfif>
													<soin>
												</font>
											</p>
										</td>
                                    </tr>
                                </table></td>
                              </tr>
                          </table></td>
                        </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td width="100%">
                      <div align="right">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="100%" bgcolor="##FFFFFF">&nbsp;</td>
                          </tr>
                          <tr>
                            <td width="100%" bgcolor="##006699"><p style="margin-left: 3; margin-right: 3"><font color="##FFFFFF" size="1" face="Aero">FORMA DE COBRO</font></p></td>
                          </tr>
                          <tr>
                            <td width="100%">
                              <div align="right">  
                                <table border="0" width="108%" cellspacing="0" cellpadding="0">
                                  <tr>
                                    <td width="49%"><p style="margin-left: 3; margin-right: 3" align="left"><b><font face="Aero" size="1">A.Cuenta corriente con RACSA:&nbsp;&nbsp;&nbsp;</font></b></p></td>
                                    <td width="5%"><p style="margin-left: 3; margin-right: 3" align="right"><font size="1" face="Aero"><b>&nbsp;</b>SI</font></p></td>
                                    <td width="6%">
										<p style="margin-left: 3; margin-right: 3" align="left">
											<font face="Aero" size="1">
												<soin>
													<cfif isdefined('rsFormaCobro') and rsFormaCobro.recordCount GT 0>
														<cfif rsFormaCobro.CTcobro EQ '4'>	<!--- A cuenta Corriente con Racsa --->
															X
														<cfelse>
															&nbsp;
														</cfif>
													</cfif>
												<soin>
											</font>
										</p>
									</td>
                                    <td width="17%"><p style="margin-left: 3; margin-right: 3" align="right"><font face="Aero" size="1">&nbsp;NO&nbsp;</font></p></td>
                                    <td width="5%">
										<p style="margin-left: 3; margin-right: 3" align="left">
											<font face="Aero" size="1">
												<soin>
													<cfif isdefined('rsFormaCobro') and rsFormaCobro.recordCount GT 0>
														<cfif rsFormaCobro.CTcobro EQ '2' or rsFormaCobro.CTcobro EQ '3'>	<!--- 2. CARGO SUJETO A TARJETA y 3. CARGO SUJETO A CUENTA BANCARIA --->
															X
														<cfelse>
															&nbsp;
														</cfif>
													</cfif>												
												<soin>
											</font>
										</p>
									</td>
                                    <td width="29%"><p style="margin-left: 3; margin-right: 3" align="left">&nbsp;</p></td>
                                  </tr>
                                </table>
                            </div></td>
                          </tr>
                          <tr>
                            <td width="100%">
								<p style="margin-left: 3; margin-right: 3">
									<b>
										<font face="Aero" size="1">
											<!--- rsFormaCobro.CTcobro=2 (Pago Aut. a Tarjeta) --->											
											B.Cargo Automático a Tarjeta de Crédito o Débito:									
										</font>
									</b>
								</p></td>
                          </tr>
                          <tr>
                            <td width="100%">
								<cfset pagoAuto = false>
								<cfset CTbcoRef_T1 = "">									
								<cfset CTbcoRef_T2 = "">								
								<cfset CTbcoRef_T3 = "">
								<cfset CTbcoRef_T4 = "">	
								<cfset CTbcoRef_T5 = "">								
								
								<cfif isdefined('rsFormaCobro') and rsFormaCobro.recordCount GT 0>
									<cfif rsFormaCobro.CTcobro EQ '2'>	<!--- CARGO SUJETO A TARJETA --->
										<cfset pagoAuto = true>
									</cfif>
								</cfif>								
								
								<cfif pagoAuto and rsFormaCobro.CTbcoRef NEQ ''>
									<cfset CTbcoRef_T1 = Mid(rsFormaCobro.CTbcoRef, 1, 4)>	<!--- 0,4 --->
									<cfset CTbcoRef_T2 = Mid(rsFormaCobro.CTbcoRef, 5, 4)>	<!--- 4,8 --->
									<cfset CTbcoRef_T3 = Mid(rsFormaCobro.CTbcoRef, 9, 4)>	<!--- 8,12 --->
									<cfset CTbcoRef_T4 = Mid(rsFormaCobro.CTbcoRef, 13, 4)>	<!--- 12,16 --->
									<cfset CTbcoRef_T5 = rsFormaCobro.CTverificadorTC>
								</cfif>								
                              <table border="0" width="100%" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td width="39%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">N° de Tarjeta:</font></p></td>
                                  <td width="13%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1"><soin>#CTbcoRef_T1#<soin></font></p></td>
                                  <td width="4%" align="center"><p align="center" style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">-</font></p></td>
                                  <td width="14%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1"><soin>#CTbcoRef_T2#<soin></font></p></td>
                                  <td width="4%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">-</font></p></td>
                                  <td width="14%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1"><soin>#CTbcoRef_T3#<soin></font></p></td>
                                  <td width="4%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">-</font></p></td>
                                  <td width="15%" align="center"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1"><soin>#CTbcoRef_T4#<soin></font></p></td>
                                </tr>
                            </table></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%">
                      <div align="right">  
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="29%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Dígitos de Verificación:</font></p></td>
                            <td width="19%"><p style="margin-left: 3; margin-right: 3" align="center"><font face="Aero" size="1"><soin><cfif CTbcoRef_T5 neq ''>#CTbcoRef_T5#<cfelse>&nbsp;</cfif><soin></font></p></td>
                            <td width="23%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Vence (mes-año):</font></p></td>
                            <td width="7%">
								<p style="margin-left: 3; margin-right: 3" align="center">
									<font face="Aero" size="1">
										<soin>
											<cfif pagoAuto and rsFormaCobro.CTmesVencimiento NEQ ''>
												#rsFormaCobro.CTmesVencimiento#									
											<cfelse>
												&nbsp;
											</cfif>												
										<soin>
									</font>
								</p></td>
                            <td width="5%"><p style="margin-left: 3; margin-right: 3" align="center"><font face="Aero" size="1">-</font></p></td>
                            <td width="17%">
								<p style="margin-left: 3; margin-right: 3" align="center">
									<font size="1" face="Aero">
										<soin>
											<cfif pagoAuto and rsFormaCobro.CTanoVencimiento NEQ ''>
												#rsFormaCobro.CTanoVencimiento#									
											<cfelse>
												&nbsp;
											</cfif>							
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%">
                      <div align="right">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="19%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Ente Emisor:</font></p></td>
                            <td width="43%">
								<p style="margin-left: 3; margin-right: 3">
									<font size="1" face="Aero">
										<soin>
											<cfif pagoAuto and rsFormaCobro.EFnombre NEQ ''>
												#rsFormaCobro.EFnombre#									
											<cfelse>
												&nbsp;
											</cfif>											
										<soin>
									</font>
								</p>
							</td>
                            <td width="23%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Tipo de Tarjeta:</font></p></td>
                            <td width="15%">
								<p style="margin-left: 3; margin-right: 3">
									<font size="1" face="Aero">
										<cfif pagoAuto and rsFormaCobro.MTnombre NEQ ''>
											#rsFormaCobro.MTnombre#									
										<cfelse>
											&nbsp;
										</cfif>										
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="100%" colspan="4" bgcolor="##FFFFFF">&nbsp;</td>
                          </tr>
                          <tr>
                            <td width="100%" colspan="4" bgcolor="##006699"><p style="margin-left: 3; margin-right: 3"><b><i><font size="1" face="Aero" color="##FFFFFF">Propietario de la Tarjeta:</font></i></b></p></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%">
                      <div align="right">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <!---<tr>
                            <td width="17%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">1<font lang="JA">°</font>Apellido:</font></p></td>
                            <td width="27%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<cfif pagoAuto and rsFormaCobro.CTapellido1TH NEQ ''>
											#rsFormaCobro.CTapellido1TH#									
										<cfelse>
											&nbsp;
										</cfif>									
									</font>
								</p>
							</td>
                            <td width="28%"><p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">2<font lang="JA">°</font> Apellido:</font></p></td>
                            <td width="28%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<cfif pagoAuto and rsFormaCobro.CTapellido2TH NEQ ''>
											#rsFormaCobro.CTapellido2TH#									
										<cfelse>
											&nbsp;
										</cfif>									
									</font>
								</p>
							</td>
                          </tr>--->
                          <tr>
                            <td width="17%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Nombre:</font></p></td>
                            <td width="27%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<cfif pagoAuto and rsFormaCobro.CTnombreTH NEQ ''>
											#rsFormaCobro.CTnombreTH# #rsFormaCobro.CTapellido1TH# #rsFormaCobro.CTapellido2TH#							
										<cfelse>
											&nbsp;
										</cfif>										
									</font>
								</p>
							</td>
                            <td width="28%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Cédula o Pasaporte:</font></p></td>
                            <td width="28%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<cfif pagoAuto and rsFormaCobro.CTcedulaTH NEQ ''>
											#rsFormaCobro.CTcedulaTH#									
										<cfelse>
											&nbsp;
										</cfif>									
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="17%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Nacionalidad:</font></p></td>
                            <td width="83%" colspan="3">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<cfif pagoAuto and rsFormaCobro.PpaisTH NEQ ''>
											#rsFormaCobro.PpaisTH#									
										<cfelse>
											&nbsp;
										</cfif>					
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="100%" colspan="4">&nbsp;</td>
                          </tr>
                          <tr>
                            <td width="100%" colspan="4"><p style="margin-left: 3; margin-right: 3"><b><font size="1" face="Aero">C.Cuenta Bancaria: (P.A.R. - Pago Automático de Recibo)</font></b></p></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%">
                      <div align="right">
						<cfset ctaCorriente = false>
						<cfif isdefined('rsFormaCobro') and rsFormaCobro.recordCount GT 0>						
 							<cfif rsFormaCobro.CTbcoRef NEQ '' and (Mid(rsFormaCobro.CTbcoRef, 1, 3) EQ '100')>
								<cfset ctaCorriente = true>
							</cfif>
						</cfif>						  
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="37%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Tipo de Cuenta:</font></p></td>
                            <td width="63%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif ctaCorriente>
												Corriente
											<cfelse>
												Ahorros / electr&oacute;nica
											</cfif>									
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="37%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Nombre del Cuentacorrentista:</font></p></td>
                            <td width="63%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<cfif rsFormaCobro.CTnombreTH NEQ '' and rsFormaCobro.CTcobro eq '3'>
											#rsFormaCobro.CTnombreTH# #rsFormaCobro.CTapellido1TH# #rsFormaCobro.CTapellido2TH#
										<cfelse>
											&nbsp;
										</cfif>								
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="37%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Cédula o Pasaporte:</font></p></td>
                            <td width="63%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<cfif rsFormaCobro.CTcedulaTH NEQ '' and rsFormaCobro.CTcobro eq '3'>
											#rsFormaCobro.CTcedulaTH#
										<cfelse>
											&nbsp;
										</cfif>		
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="37%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Número de Cuenta:</font></p></td>
                            <td width="63%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif rsFormaCobro.CTbcoRef NEQ '' and rsFormaCobro.CTcobro eq '3'>
												#Mid(rsFormaCobro.CTbcoRef, 9, len(rsFormaCobro.CTbcoRef))#
 											<cfelse>
												&nbsp;
											</cfif>
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="37%"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero">Banco:</font></p></td>
                            <td width="63%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											<cfif rsFormaCobro.EFnombre NEQ '' and rsFormaCobro.CTcobro eq '3'>
												#rsFormaCobro.EFnombre#
											<cfelse>
												&nbsp;
											</cfif>	
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                          <tr>
                            <td width="37%"><font face="Aero" size="1">Sucursal:</font></td>
                            <td width="63%">
								<p style="margin-left: 3; margin-right: 3">
									<font face="Aero" size="1">
										<soin>
											&nbsp;
										<soin>
									</font>
								</p>
							</td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                  <tr>
                    <td width="100%">
                      <div align="right">
                        <table border="1" width="100%" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="100%" bgcolor="##FFFFFF">&nbsp;</td>
                          </tr>
                          <tr>
                            <td width="100%" bgcolor="##006699"><p style="margin-left: 3; margin-right: 3"><font color="##FFFFFF" face="Aero" size="1">SEGUNDA: OBJETO DE LA SOLICITUD</font></p></td>
                          </tr>
                          <tr>
                            <td width="100%">
                              <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1">La presente SOLICITUD tiene como fin brindar a EL SOLICITANTE, el servicio de acceso a Internet de RACSA de acuerdo con la modalidad que EL SOLICITANTE escoja al momento de firmar este documento. </font> </p></td>
                          </tr>
                          <tr>
                            <td width="100%" bgcolor="##006699"><p style="margin-left: 3; margin-right: 3"><font size="1" face="Aero" color="##FFFFFF">TERCERA: VIGENCIA</font></p></td>
                          </tr>
                          <tr>
                            <td width="100%" valign="top">
                              <p align="justify" style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> La presente SOLICITUD entrará en vigencia a partir de la fecha de su firma, por un período inicial de un año, y se podrá renovar automáticamente por períodos de un año, para lo cual operará la prórroga automática, si treinta días naturales antes de vencerse el período correspondiente ninguna de las partes manifiesta a la otra por escrito su deseo de no hacerlo. Sin embargo, EL SOLICITANTE tendrá derecho a terminar anticipadamente este servicio en cualquier momento comunicándolo a RACSA por escrito y pagando las sumas correspondientes por uso del servicio hasta el último día de uso del servicio y según las condiciones de retiro anticipado. </font> </p></td>
                          </tr>
                          <tr>
                            <td width="100%" bgcolor="##006699">
                              <p style="margin-left: 3; margin-right: 3"><font color="##FFFFFF" face="Aero" size="1">CUARTA: TERMINOS Y CONDICIONES</font></p></td>
                          </tr>
                          <tr>
                            <td width="100%">
                              <p style="margin-left: 3; margin-right: 3"> <font face="Aero" size="1"> Con la firma de esta SOLICITUD, EL SOLICITANTE, señala que conoce y acepta en forma expresa e irrevocable todos los términos y condiciones del reglamento vigente denominado (&quot;Reglamento para la Prestación del Servicio de Internet de RACSA&quot;), por el cual se rige la prestación del servicio solicitado. Igualmente, señala que conoce y acepta en forma expresa e irrevocable todos los términos y condiciones vigentes en el reglamento denominado &quot;Reglamento Autónomo del Servicio para Regulación de Correo Electrónico Masivo o No Deseado&quot; (SPAM), los cuales formarán parte integrante del presente documento. </font> </p></td>
                          </tr>
                          <tr>
                            <td width="100%" bgcolor="##006699">
                              <p style="margin-left: 3; margin-right: 3"><font color="##FFFFFF" size="1" face="Aero">QUINTA:NOTIFICACIONES</font> </td>
                          </tr>
                          <tr>
                            <td width="100%">
                              <p style="margin-left: 3; margin-right: 3"><font face="Aero" size="1">Para efectos de notificaciones administrativas y judiciales (según lo dispuesto por la ley N°7637 del 21 de octubre de 1996, publicada en el Diario Oficial La Gaceta Nº 211 del lunes 4 de noviembre de 1996), EL SOLICITANTE señala como domicilio el indicado en la casilla de envío de facturación, o en su defecto la consignada en las casillas de Persona Física o Jurídica. Asimismo, dichas notificaciones pueden ser remitidas vía fax al número indicado en las casillas correspondientes.</font></td>
                          </tr>
                        </table>
                    </div></td>
                  </tr>
                </table>
            </div></td>
          </tr>
      </table></td>
    </tr>
    <tr>
      <td width="100%">
        <table border="0" width="100%" cellspacing="0" cellpadding="0">
          <tr>
            <td width="50%" align="center"></td>
            <td width="50%" align="center"></td>
          </tr>
          <tr>
            <td width="50%" align="center"></td>
            <td width="50%" align="center"></td>
          </tr>
          <tr>
            <td width="50%" align="center"></td>
            <td width="50%" align="center"></td>
          </tr>
          <tr>
            <td width="50%" align="center"></td>
            <td width="50%" align="center"></td>
          </tr>
          <tr>
            <td width="50%" align="center"></td>
            <td width="50%" align="center"></td>
          </tr>
          <tr>
            <td width="50%" align="center"></td>
            <td width="50%" align="center"></td>
          </tr>
          <br>
          <br>
          <br>
          <tr>
            <td width="50%" align="center"><font face="Aero">___________________________</font></td>
            <td width="50%" align="center"><font face="Aero">________________________________________</font></td>
          </tr>
          <tr>
            <td width="50%" align="center"><font face="Aero" size="2">FIRMA DEL SOLICITANTE</font></td>
            <td width="50%" align="center"><font face="Aero" size="2">FIRMA DE ACEPTACIÓN DEL CARGO A TARJETA O</font></td>
          </tr>
          <tr>
            <td width="50%" align="center"></td>
            <td width="50%" align="center"><font face="Aero" size="2">CUENTA BANCARIA – (PAR – Pago Automático de Recibo)</font></td>
          </tr>
          <tr>
            <td width="100%" colspan="2" align="center">&nbsp;</td>
          </tr>
          <br>
          <tr>
            <td width="100%" colspan="2" align="center"><p align="center"><font size="1" color="##FF0000" face="Aero">ORIGINAL : RACSA</font></p></td>
          </tr>
      </table></td>
    </tr>
  </table>
</cfoutput>
</body>

</html>
