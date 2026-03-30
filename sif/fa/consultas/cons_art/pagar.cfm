<cf_template>
<cf_templatearea name="title">
	Confirmar factura</cf_templatearea>
<cf_templatearea name="body">
	<!--- Cajas asignadas al usuario --->
	<cfquery name="rsCajasUsuario" datasource="#Session.DSN#">
		select a.FCid, b.FCcodigo, b.FCdesc, b.Ocodigo
		from UsuariosCaja a, FCajas b
		where a.EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FCid = b.FCid
	</cfquery>
	<!--- Impuestos --->
	<cfquery name="rsImpuestos" datasource="#Session.DSN#">
		select Icodigo, Idescripcion, Iporcentaje from Impuestos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Idescripcion                                 
	</cfquery>
	<!--- Departamentos --->
	<cfquery name="rsDepartamentos" datasource="#session.dsn#">
		select Dcodigo, Ddescripcion
		from Departamentos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
	<!--- Almacenes --->
	<cfquery name="rsAlmacenes" datasource="#session.dsn#">
		select Aid, Bdescripcion
		from Almacen
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
	<!--- Vendedores --->
	<cfquery name="rsVendedores" datasource="#session.dsn#">
		select Ocodigo, FVid, FVnombre
		from FVendedores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!--- Transacciones (de CxC) para una caja --->
	<cfquery name="rsTiposTransaccion" datasource="#Session.DSN#">
		select a.FCid, a.CCTcodigo, b.CCTdescripcion, isnull(convert(varchar,a.Tid),'') as Tid
		from TipoTransaccionCaja a, CCTransacciones b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Ecodigo = b.Ecodigo 
			and a.CCTcodigo = b.CCTcodigo
	</cfquery>
	<cfoutput>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="2"><strong>Los siguientes datos son necesarios para continuar</strong></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<form name="form1" action="pagar_sql.cfm" method="post">
		<tr>
			<td><strong>Caja&nbsp;:&nbsp;</strong></td>
			<td>
				<select name="FCid" onChange="javascrip: tiposTransaccion();vendedores();">
					<cfloop query="rsCajasUsuario">
						<option value="#FCid#|#Ocodigo#">#trim(FCcodigo)#, #FCdesc#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td><strong>Transacción&nbsp;:&nbsp;</strong></td>
			<td>
				<select name="CCTcodigo"></select>
			</td>
		</tr>
		<tr>
			<td><strong>Impuesto&nbsp;:&nbsp;</strong></td>
			<td>
				<select name="Icodigo" tabindex="1">
          <cfloop query="rsImpuestos"> 
            <option value="#rsImpuestos.Icodigo#">#rsImpuestos.Idescripcion#</option>
          </cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td><strong>Cliente&nbsp;:&nbsp;</strong></td>
			<td>
				<cf_sifsociosnegocios2 sntiposocio="C">
			</td>
		</tr>
		<tr>
			<td><strong>Departamento&nbsp;:&nbsp;</strong></td>
			<td>
				<select name="Dcodigo">
					<cfloop query="rsDepartamentos">
						<option value="#Dcodigo#">#Ddescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td><strong>Almac&eacute;n&nbsp;:&nbsp;</strong></td>
			<td>
				<select name="Alm_Aid">
					<cfloop query="rsAlmacenes">
						<option value="#Aid#">#Bdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td><strong>Vendedor&nbsp;:&nbsp;</strong></td>
			<td>
				<select name="FVid"></select>
			</td>
		</tr>
		<tr>
			<td><strong>Fecha&nbsp;:&nbsp;</strong></td>
			<td>
				<cf_sifcalendario name="ETfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
		<td colspan="2"><input type="image" src="images/btn_generar_factura.gif"></td>
		</tr>
		</form>
	</table>	
	</cfoutput>
	<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="javascript" type="text/javascript">
		<!--// //poner a código javascript 
		//incluye qforms en la página
		// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// Qforms. carga todas las librerías por defecto
		qFormAPI.include("*");
		//inicializa qforms en la página
		qFormAPI.errorColor = "#FFFFCC";
		//form1
		objForm = new qForm("form1");
		//descripciones del form
		<cfoutput>
		objForm.FCid.description = "Caja";
		objForm.CCTcodigo.description = "#JSStringFormat('Transacción')#";
		objForm.Icodigo.description = "Impuesto";
		objForm.SNcodigo.description = "Cliente";
		objForm.Dcodigo.description = "Departamento";
		objForm.Alm_Aid.description = "Almacen";
		objForm.FVid.description = "Vendedor";
		objForm.ETfecha.description = "Fecha";
		</cfoutput>
		//campos requeridos del form
		objForm.FCid.required = true;
		objForm.CCTcodigo.required = true;
		objForm.Icodigo.required = true;
		objForm.SNcodigo.required = true;
		objForm.Dcodigo.required = true;
		objForm.Alm_Aid.required = true;
		objForm.FVid.required = true;
		objForm.ETfecha.required = true;
		//función para agregar al combo de tipos de transacciones, los correspondientes a la caja
		function tiposTransaccion() {
			var form = document.form1;
			var caja = form.FCid.value.split("|")[0];
			var combo = form.CCTcodigo;
			var cont = 0;
			combo.length=0;
			<cfoutput query="rsTiposTransaccion">
				if (#FCid#==caja){
					combo.length=cont+1;
					combo.options[cont].value='#CCTcodigo#';
					combo.options[cont].text='#CCTdescripcion#';
					cont++;
				}
			</cfoutput>
		}
		//función para agregar al combo de vendedores, los correspondientes a la caja
		function vendedores() {
			var form = document.form1;
			var oficina = form.FCid.value.split("|")[1];
			var combo = form.FVid;
			var cont = 0;
			combo.length=0;
			<cfoutput query="rsVendedores">
				if (#Ocodigo#==oficina){
					combo.length=cont+1;
					combo.options[cont].value='#FVid#';
					combo.options[cont].text='#FVnombre#';
					cont++;
				}
			</cfoutput>
		}
		//carga inicial de los tipos de transacciones y de los vendedores
		tiposTransaccion();
		vendedores();
		//-->
	</script>
</cf_templatearea>
</cf_template>

