<!--- ABG: Sincronizacion de Socios de Negocios a LDCOM Interfaz LD-SIF Ver. 1.0 --->
<!--- Este componente crea y actualiza la informacion de los socios de negocios de SIF en el sistema LDCOM--->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cfcomponent extends="Interfaz_Base">
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<!--- Rutina para Obtener Parametros a Ocupar --->
	<!--- <cfquery name="rsParametros" datasource="sifinterfaces">
	select * 
	from SIFLD_Parametros
	where Pcodigo = VALOR
	</cfquery> --->

	<!--- Obtiene las empresas a sincronizar --->
	<cfquery name="rsEmpresas" datasource="sifinterfaces">
		select EQUcodigoOrigen,EQUidSIF, EQUdescripcion
		from SIFLD_Equivalencia
		where CATcodigo like 'CADENA'
		and SIScodigo like 'LD'
	</cfquery>
	<cfif isdefined("rsEmpresas") and rsEmpresas.recordcount GT 0>
	<cfloop query="rsEmpresas"> <!---Abre loop empresa--->
		<!--- Obtiene el Id de empresa para la cadena --->
		<cfquery name="rsEmpresaLD" datasource="ldcomp">
			select Emp_Id
			from Cadena
			where Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
		</cfquery>
		<cfif len(rsEmpresaLD.Emp_Id) GT 0>
			<cfset LvarEmpId = rsEmpresaLD.Emp_Id>
		<cfelse>
			<cfset LvarEmpId = 0>
		</cfif>
		
        <!--- Obtiene el parametro para saber si sincroniza los saldos de los socios en LD--->
        <cftry>
			<cfset ParSinc = Parametros(Ecodigo=rsEmpresas.EQUidSIF,Pcodigo=15, Parametro="Sincroniza Saldos de Socios",ExtBusqueda=true, Sistema = "LD")>
        <cfcatch>
        </cfcatch>
        </cftry>
        
        <cfset session.dsn = getConexion(rsEmpresas.EQUidSIF)>
		<!--- Extrae los socios de negocios --->
		<cfquery name="rsSocio" datasource="#session.dsn#">
			select sn.Ecodigo, sn.SNcodigo, sn.SNid, sn.SNidentificacion, sn.SNtipo,
			sn.SNnombre, sn.SNdireccion, sn.Ppais, sn.SNtelefono, sn.SNFax, sn.SNemail,
			sn.SNcodigoext, sn.SNtiposocio, isnull(sn.SNplazoentrega,0) as SNplazoentrega,
			isnull(sn.SNplazocredito,0) as SNplazocredito, sn.Mcodigo, 
			isnull(sn.SNmontoLimiteCC,0) as SNmontoLimiteCC, sn.id_direccion,sn.SNidentificacion2, 
			dv.DEnombre as Vnombre, dv.DEapellido1 as Vapellido1, dv.DEapellido2 as Vapellido2,
			dc.DEnombre as Cnombre, dc.DEapellido1 as Capellido1, dc.DEapellido2 as Capellido2
			from SNegocios sn
			left join 	DatosEmpleado dv
			on sn.Ecodigo = dv.Ecodigo
			and sn.DEidVendedor = dv.DEid
			left join 	DatosEmpleado dc
			on sn.Ecodigo = dc.Ecodigo
			and sn.DEidCobrador = dc.DEid
            where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUidSIF#">
			and sn.SNcodigo != 9999
			and left(sn.SNnumero,3) not like '002'
		</cfquery>

		<cfif isdefined("rsSocio") and rsSocio.recordcount GT 0>
		<cfloop query="rsSocio"> <!---Abre loop socio--->
		<cftry>
        	<cfif LvarEmpId EQ 0>
            	<cfthrow message="No se pudo obtener valor en LDCOM para la cuenta Empresarial de la cadena #rsEmpresas.EQUcodigoOrigen#">
            </cfif>
            <cfif not isdefined("ParSinc")>
            	<cfthrow message="No se ha configurado el parámetro Sincroniza Saldos de Socios para el sistema LDCOM">
            </cfif>
			<!---Arma codigo Externo --->
			<cfset varCodExt = "#numberformat(rsSocio.Ecodigo,000)##numberformat(rsSocio.SNcodigo,000000)#">
			<cfquery datasource="#session.dsn#">
				update SNegocios
				set SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.Ecodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.SNcodigo#">
			</cfquery>

			<!--- PAIS --->
			<cfquery name="rsEquivalencia" datasource="sifinterfaces">
				select max(EQUcodigoOrigen) as EQUcodigoOrigen
				from SIFLD_Equivalencia
				where CATcodigo like 'PAIS'
				and EQUempSIF like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresas.EQUidSIF#">
				and EQUidSIF like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.Ppais#">
			</cfquery>
			<cfif isdefined("rsEquivalencia") and rsEquivalencia.recordcount GT 0 and len(rsEquivalencia.EQUcodigoOrigen) GT 0>
				<cfset LvarPais = rsEquivalencia.EQUcodigoOrigen>
			<cfelse>
				<cfthrow message="No se ha definido la equivalencia para el Pais:#rsSocio.Ppais# en la Empresa:#rsEmpresas.EQUdescripcion#">
			</cfif>

			<!--- MONEDA --->
			<cfquery name="rsEquivalencia" datasource="sifinterfaces">
				select max(EQUcodigoOrigen) as EQUcodigoOrigen
				from SIFLD_Equivalencia
				where CATcodigo like 'MONEDA'
				and EQUempSIF like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpresas.EQUidSIF#">
				and EQUidSIF like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.Mcodigo#">
			</cfquery>
			<cfif len(rsEquivalencia.EQUcodigoOrigen)>
				<cfset LvarMoneda = rsEquivalencia.EQUcodigoOrigen>
			<cfelse>
				<cfthrow message="Error de Sincronizacion. No se ha definido la equivalencia para la Moneda:#rsSocio.Mcodigo# en la Empresa:#rsEmpresas.EQUdescripcion#">
			</cfif>

			<!--- Verifica tipo de socios para controlar si se sincroniza con tabla de Clientes o con tabla de Proveedores--->
			<cfif trim(rsSocio.SNtiposocio) EQ "P" or trim(rsSocio.SNtiposocio) EQ "A">
				<!--- Sincroniza los Proveedores de acuerdo a su RFC --->
				<cfquery datasource="ldcomp">
					update Proveedor
					set Prov_CodigoExterno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
					where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
					and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
					and ltrim(rtrim(Prov_Cedula)) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSocio.SNidentificacion)#">
				</cfquery>
				<!---Verifica si existe el socio como proveedor o debe de darse de alta --->
				<cfquery name="rsVerifica" datasource="ldcomp">
					select count(1) as verifica
					from Proveedor
					where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
					and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
					and Prov_CodigoExterno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
				</cfquery>
				<cfif isdefined("rsVerifica") and rsVerifica.verifica EQ 0>
					<!---ID Proveedor --->
					<cfquery name="rsID" datasource="ldcomp">
						select isnull(max(Prov_Id),0) + 1 as Prov_Id
						from Proveedor
						where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
					</cfquery>

					<!--- No existe Creando Proveedor para sincronizar --->
					<cfquery datasource="ldcomp">
						insert into Proveedor (Emp_Id, Prov_Id, Moneda_Id, Pais_Id, Prov_Nombre, 
						Prov_Cedula, Prov_Direccion, Prov_Email, Prov_Fax, Prov_Telefono, 
						Categoria_Id, SubCategoria_Id, Prov_Razon_Social, Cadena_Id, Prov_CodigoExterno)
						values 
						(<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Prov_Id#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPais#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,50)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSocio.SNidentificacion)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNdireccion,100)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNemail,100)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNfax,15)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNtelefono,15)#">,
						1,1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,50)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">)
					</cfquery>
				<cfelse>
					<!--- Actualizando Proveedor para sincronizar --->
					<cfquery datasource="ldcomp">
						update Proveedor 
						set Moneda_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMoneda#">, 
						Pais_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPais#">,
						Prov_Nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,50)#">, 
						Prov_Cedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSocio.SNidentificacion)#">,
						Prov_Direccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNdireccion,100)#">, 
						Prov_Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNemail,100)#">, 
						Prov_Fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNfax,15)#">,
						Prov_Telefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNtelefono,15)#">, 
						Prov_Razon_Social = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,50)#">,
                        Prov_Fec_Actualizacion = getdate()
						where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
						and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
						and Prov_CodigoExterno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
					</cfquery>
				</cfif>
			</cfif> 

			<cfif trim(rsSocio.SNtiposocio) EQ "C" or trim(rsSocio.SNtiposocio) EQ "A">
				<!--- Obtiene el saldo disponible para el cliente y Verifica Facturas Vencidas --->
                <!--- Query para saldos disponible --->
                <cfquery name="rsSaldoD" datasource="#session.dsn#">
                    select sum(case t.CCTtipo when 'D' then +(d.Dsaldo) else -(d.Dsaldo) end) as Saldo_Total, 
                        isnull(min(s.SNmontolimiteCC),0) as Limite, 
                        isnull(min(s.SNmontolimiteCC),0) - sum(case t.CCTtipo when 'D' then +(d.Dsaldo) else -(d.Dsaldo) end) as SaldoDisponible
                    from Documentos d
                        inner join SNegocios s
                        on d.Ecodigo = s.Ecodigo and d.SNcodigo = s.SNcodigo
                        inner join CCTransacciones t
                        on d.Ecodigo = t.Ecodigo and d.CCTcodigo = t.CCTcodigo
                        inner join Empresas e
                        on d.Ecodigo = e.Ecodigo
                        inner join Monedas m
                        on d.Mcodigo = m.Mcodigo and d.Ecodigo = m.Ecodigo
                    where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUidSIF#">
                    and d.Dsaldo <> 0
                    and s.SNid = <cfqueryparam cfsqltype="cf_sql_bigint" value="#rsSocio.SNid#">
                    group by d.SNcodigo, d.Mcodigo
                </cfquery>
                <cfif isdefined("rsSaldoD") and rsSaldoD.recordcount GT 0 and isnumeric(rsSaldoD.SaldoDisponible)>
                    <cfset varDisponible = rsSaldoD.SaldoDisponible>
                <cfelse>
                    <cfset varDisponible = 0>
                </cfif>
                <cfquery name="rsSaldoD" datasource="#session.dsn#">
                    select sum(case t.PFTtipo when 'D' then +(d.Total) else -(d.Total) end) as Saldo_Total 
                    from FAPreFacturaE d
                        inner join SNegocios s
                        on d.Ecodigo = s.Ecodigo and d.SNcodigo = s.SNcodigo
                        inner join FAPFTransacciones t
                        on d.Ecodigo = t.Ecodigo and d.PFTcodigo = t.PFTcodigo
                        inner join Monedas m
                        on d.Mcodigo = m.Mcodigo and d.Ecodigo = m.Ecodigo
                    where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUidSIF#">
                    and s.SNid = <cfqueryparam cfsqltype="cf_sql_bigint" value="#rsSocio.SNid#">
                    group by d.SNcodigo, d.Mcodigo
                </cfquery>
                <cfif isdefined("rsSaldoD") and rsSaldoD.Saldo_Total NEQ 0 and isnumeric(rsSaldoD.Saldo_Total)>
                    <cfset varDisponible = varDisponible - rsSaldoD.Saldo_Total>
                </cfif>
                <!--- Facturas Vencidas --->
                <cfquery name="rsVencidas" datasource="#session.dsn#">
                	select d.Ddocumento
					from Documentos d
					where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUidSIF#">
                    and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_bigint" value="#rsSocio.SNcodigo#">
                    and d.Dvencimiento < getdate()
                </cfquery>
				<cfif isdefined("rsVencidas") and rsVencidas.recordcount GT 0>
                	<cfset varVencidas = 1>
                <cfelse>
                	<cfset varVencidas = 0>
                </cfif>
                
				<!--- Sincroniza los Clientes que hayan sido registrados desde LDCOM--->
				<cfquery datasource="ldcomp">
					update Cliente
					set Cliente_CodigoExterno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
					where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
					and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
					and ltrim(rtrim(Cliente_Cedula)) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSocio.SNidentificacion)#">
					and Tipo_Id != 3
				</cfquery>
				<!---Verifica si existe el socio como cliente o debe de darse de alta --->
				<cfquery name="rsVerifica" datasource="ldcomp">
					select count(1) as verifica
					from Cliente
					where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
					and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
					and Cliente_CodigoExterno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
				</cfquery>
				<cfif isdefined("rsVerifica") and rsVerifica.verifica EQ 0>
					<!---ID Cliente --->
					<cfquery name="rsID" datasource="ldcomp">
						select isnull(max(Cliente_Id),0) + 1 as Cliente_Id
						from Cliente
						where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
					</cfquery>

						<!--- No existe Creando Cliente para sincronizar --->
					<cfquery datasource="ldcomp">
						insert into Cliente 
						(Emp_Id, Cliente_Id, Cliente_Nombre, Cliente_Nombre_Comercial, Cliente_Cedula,
						Cliente_Identificacion, Cliente_Direccion, Cliente_Email, Cliente_Fax, Cliente_Telefono,
						Cliente_Plazo, Cadena_id, Tipo_Id, Cliente_Credito_Limite, Cliente_Credito_Saldo, Cliente_Factura_Vencida, 
						Cliente_Vendedor_Default, Cliente_Cobrador_Default, Cliente_CodigoExterno)
						values 
						(<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Cliente_Id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,50)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,60)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(trim(rsSocio.SNidentificacion),25)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNidentificacion2,20)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNdireccion,100)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNemail,100)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNfax,15)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNtelefono,15)#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNplazocredito#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">,
									2,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rsSocio.SNmontoLimiteCC#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#varDisponible#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#varVencidas#">,
						1, 1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">)
					</cfquery>
				<cfelse>
					<!--- Actualizando Cliente para sincronizar --->
					<cfquery datasource="ldcomp">
						update Cliente 
						set Cliente_Nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,50)#">, 
						Cliente_Nombre_Comercial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNnombre,60)#">, 
						Cliente_Cedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(trim(rsSocio.SNidentificacion),25)#">,
						Cliente_Identificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNidentificacion2,20)#">, 
						Cliente_Direccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNdireccion,100)#">, 
						Cliente_Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNemail,100)#">, 
						Cliente_Fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNfax,15)#">, 
						Cliente_Telefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocio.SNtelefono,15)#">,
						Cliente_Plazo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSocio.SNplazocredito#">, 
						Cliente_Credito_Limite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocio.SNmontoLimiteCC#">, 
                        <cfif ParSinc> <!---Si el parametro esta activo actualiza saldos --->
	                        Cliente_Credito_Saldo =  <cfqueryparam cfsqltype="cf_sql_money" value="#varDisponible#">,
                        </cfif>
                        Cliente_Factura_Vencida = <cfqueryparam cfsqltype="cf_sql_integer" value="#varVencidas#">,
                        Cliente_Fec_Actualizacion = getdate()
						where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
						and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
						and Cliente_CodigoExterno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
                        and Tipo_Id not in (3,4,5) <!--- Con esto se evita planchar los datos de los Sub Clientes --->
					</cfquery>
				</cfif>
			</cfif>

			<!--- Sincroniza Direcciones del Socio --->
			<cfquery name="rsSocioD" datasource="#session.dsn#">
				select snd.SNid, snd.id_direccion, snd.Ecodigo, snd.SNcodigo,
				isnull(SNDlimiteFactura,0) as SNDlimiteFactura, snd.SNnombre,
				snd.SNcodigoext, snd.SNDtelefono, snd.SNDFax, snd.SNDemail, 
				ds.direccion1, ds.direccion2, ds.ciudad, ds.estado, ds.codPostal,
				case 
				when snd.id_direccion =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.id_direccion#"> then 'P' 
				else 'S' end as Tipo_Dir 
				from SNDirecciones snd
				inner join DireccionesSIF ds
				on snd.id_direccion = ds.id_direccion 
				where snd.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.SNid#">
				and snd.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.SNcodigo#">
			</cfquery>
			<cfif isdefined("rsSocioD") and rsSOcioD.recordcount GT 0>
			<cfloop query="rsSocioD"> <!--- Abre loop Direcciones --->
				<!---Para Proveedores --->
				<cfif rsSocio.SNtiposocio EQ "P" OR rsSocio.SNtiposocio EQ "A">
					<cfquery name="rsID" datasource="ldcomp">
						select Prov_Id
						from Proveedor
						where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
						and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">
						and Prov_CodigoExterno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
					</cfquery>
			
					<cfif isdefined("rsID") and rsID.recordcount GT 0>
					<cfloop query="rsID"> <!---Abre loop agencias--->
						<!--- Todas las direcciones que se den de alta en LD apuntan a la principal --->
						<cfif rsSocioD.Tipo_Dir EQ "P">
							<cfquery datasource="ldcomp">
								update Proveedor_Agencia
								set Agencia_CodigoDireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNcodigoext#">
								where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
								and Prov_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Prov_Id#">
								and (Agencia_Id = 1 OR isnull(Agencia_CodigoDireccion,'') = '')
							</cfquery>
						</cfif>
						<!--- Verifica si se debe de crear la Direccion --->
						<cfquery name="rsVerifica" datasource="ldcomp">
							select count(1) as verifica
							from Proveedor_Agencia
							where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
							and Prov_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Prov_Id#">
							and Agencia_CodigoDireccion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNcodigoext#">
						</cfquery>
						<cfif rsVerifica.verifica EQ 0>
							<cfquery name="rsAID" datasource="ldcomp">
								select isnull(max(Agencia_Id),0) + 1 as Agencia_Id
								from Proveedor_Agencia
								where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
								and Prov_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Prov_Id#">
							</cfquery>
							<cfquery datasource="ldcomp">
								insert into Proveedor_Agencia (Emp_Id, Prov_Id, Agencia_Id, Agencia_Nombre, Agencia_Cedula,
									Agencia_Direccion, Agencia_Email, Agencia_Fax, Agencia_Telefono, Agencia_Dia_Reposicion,
								    Agencia_Fec_Actualizacion, Agencia_Plazo_Credito, Agencia_CodigoDireccion)
								values
									(<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">,
								    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Prov_Id#">,
								    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAID.Agencia_Id#">,
								    <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocioD.SNnombre,50)#">,
								    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSocio.SNidentificacion)#">,
								    <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocioD.direccion1 & " " & rsSocioD.direccion2 & " " & rsSocioD.ciudad & " " & rsSocioD.estado & " " & rsSocioD.codPostal,100)#">,
								    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNDemail#">,
								    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNDFax#">,
								    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNDtelefono#">,
								    0,getdate(),0,
								    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNcodigoext#">)
							</cfquery>
						<cfelse>
							<!--- Todas las direcciones que se den de alta en LD apuntan a la principal --->
							<cfquery datasource="ldcomp">
								update Proveedor_Agencia
								set 
								Agencia_Nombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocioD.SNnombre,50)#">,
								Agencia_Cedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsSocio.SNidentificacion)#">,
								Agencia_Direccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsSocioD.direccion1 & " " & rsSocioD.direccion2 & " " & rsSocioD.ciudad & " " & rsSocioD.estado & " " & rsSocioD.codPostal,100)#">,
								Agencia_Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNDemail#">,
								Agencia_Fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNDFax#">,
								Agencia_Telefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNDtelefono#">,
								Agencia_Fec_Actualizacion = getdate()
								where Emp_Id =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEmpId#">
								and Prov_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsID.Prov_Id#">
								and Agencia_CodigoDireccion like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSocioD.SNcodigoext#">                                         
							</cfquery>
						</cfif>
					</cfloop> <!--- Cierra loop para Agencia --->
					</cfif>
				</cfif>
				<!---Para Clientes --->
				<cfif rsSocio.SNtiposocio EQ "C" OR rsSocio.SNtiposocio EQ "A">
					<!---En clientes no se manejan las direcciones de socio--->
				</cfif>
			</cfloop> <!--- Cierra loop para Direcciones del Socio --->
			</cfif>

		<cfcatch type="any">
			<cfoutput>
				<table>
					<tr>
						<td>
							Error: #cfcatch.message#
						</td>
					</tr>
					<cfif isdefined("cfcatch.detail") AND len(cfcatch.detail) NEQ 0>
						<tr>
							<td>
								Detalles: #cfcatch.detail#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.sql") AND len(cfcatch.sql) NEQ 0>
						<tr>
							<td>
								SQL: #cfcatch.sql#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.queryError") AND len(cfcatch.queryError) NEQ 0>
						<tr>
							<td>
								QUERY ERROR: #cfcatch.queryError#
							</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.where") AND len(cfcatch.where) NEQ 0>
						<tr>
							<td>
								Parametros: #cfcatch.where#
							</td>
						</tr>
					</cfif>
				</table>
			</cfoutput>

			<cfif isdefined("cfcatch.Message")>
				<cfset Mensaje="#cfcatch.Message#">
			<cfelse>
				<cfset Mensaje="">
			</cfif>
			<cfif isdefined("cfcatch.Detail")>
				<cfset Detalle="#cfcatch.Detail#">
			<cfelse>
				<cfset Detalle="">
			</cfif>
			<cfif isdefined("cfcatch.sql")>
				<cfset SQL="#cfcatch.sql#">
			<cfelse>
				<cfset SQL="">
			</cfif>
			<cfif isdefined("cfcatch.where")>
				<cfset PARAM="#cfcatch.where#">
			<cfelse>
				<cfset PARAM="">
			</cfif>
			<cfif isdefined("cfcatch.StackTrace")>
				<cfset PILA="#cfcatch.StackTrace#">
			<cfelse>
				<cfset PILA="">
			</cfif>

			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, 
                Ecodigo, Usuario)
				values 
				('Sinc_Socios', 
				'',
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.SNcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">,
                null) 
			</cfquery>
		</cfcatch>    
		</cftry>
		</cfloop> <!---Cierra loop socio--->
		</cfif>

		<!--- Socios Genericos --->
		<cfset varCodExt = "#numberformat(rsSocio.Ecodigo,000)#009999">
		<cftry>
			<cfquery datasource="#session.dsn#">
				update SNegocios
				set SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.Ecodigo#">
				and SNcodigo = 9999
			</cfquery>
			<cfquery datasource="ldcomp">
				update Proveedor 
				set Prov_CodigoExterno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">,
                Prov_Fec_Actualizacion = getdate()
				where Prov_Cedula like '0'
				or isnull(Prov_Cedula,'') = ''
			</cfquery>
			<cfquery datasource="ldcomp">
				update Cliente
				set Cliente_CodigoExterno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodExt#">,
                Cliente_Fec_Actualizacion = getdate()
				where Cliente_Cedula like '0'
				or isnull(Cliente_Cedula, '') = ''
			</cfquery>
		<cfcatch>
			<cfif isdefined("cfcatch.Message")>
				<cfset Mensaje="#cfcatch.Message#">
			<cfelse>
				<cfset Mensaje="">
			</cfif>
			<cfif isdefined("cfcatch.Detail")>
				<cfset Detalle="#cfcatch.Detail#">
			<cfelse>
				<cfset Detalle="">
			</cfif>
			<cfif isdefined("cfcatch.sql")>
				<cfset SQL="#cfcatch.sql#">
			<cfelse>
				<cfset SQL="">
			</cfif>
			<cfif isdefined("cfcatch.where")>
				<cfset PARAM="#cfcatch.where#">
			<cfelse>
				<cfset PARAM="">
			</cfif>
			<cfif isdefined("cfcatch.StackTrace")>
				<cfset PILA="#cfcatch.StackTrace#">
			<cfelse>
				<cfset PILA="">
			</cfif>

			<cfquery datasource="sifinterfaces">
			insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila,
                Ecodigo, Usuario)
				values 
				('Sinc_Socios', 
				'',
				9999,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresas.EQUcodigoOrigen#">,
                null) 
			</cfquery>	
		</cfcatch>
		</cftry>
	</cfloop> <!---Cierra loop empresa--->
	</cfif>
</cffunction>
</cfcomponent>