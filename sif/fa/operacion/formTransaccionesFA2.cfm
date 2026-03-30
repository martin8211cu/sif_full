<cfif not isDefined("Form.NuevoE") and not isDefined("Form.NuevoL")>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset FCid = Trim(arreglo[1])>
		<cfset ETnumero = Trim(arreglo[2])>
 		<cfif sizeArreglo EQ 3>
			<cfset DTlinea = Trim(arreglo[3])>
			<cfset modoDet = "CAMBIO">
		</cfif>		
	<cfelse>
		<cfset FCid = Trim(Form.FCid)>
		<cfset ETnumero = Trim(Form.ETnumero)>
		<cfif isDefined("Form.DTlinea") and Len(Trim(Form.DTlinea)) NEQ 0>
			<cfset DTlinea = Trim(Form.DTlinea)>
		</cfif>
	</cfif>
</cfif>

<!--- Cajas --->
<cfquery name="rsCajas" datasource="#Session.DSN#">
	select 
		convert(varchar,FCid) as FCid,
		a.FCcodigo,
		a.FCdesc,		
		convert(varchar,a.Ccuenta) as Ccuenta,
		a.Ocodigo,
		b.Odescripcion,
		c.Cformato,
		c.Cdescripcion	
	from FCajas a, Oficinas b, CContables c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Caja#" >
	  and a.Ecodigo = b.Ecodigo
	  and a.Ocodigo = b.Ocodigo	
	  and a.Ecodigo = c.Ecodigo
	  and a.Ccuenta = c.Ccuenta	
</cfquery>

<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Ocodigo                      
</cfquery>

<!--- Cuentas --->
<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select convert(varchar,Ccuenta) as Ccuenta, Cformato, Cdescripcion from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Cformato                      
</cfquery>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select convert(varchar,Mcodigo) as Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<!--- Impuestos --->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion, Iporcentaje from Impuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Idescripcion                                 
</cfquery>

<!--- Transacciones (de CxC) para una caja --->
<cfquery name="rsTiposTransaccion" datasource="#Session.DSN#">
	select a.CCTcodigo, b.CCTdescripcion, isnull(convert(varchar,a.Tid),'') as Tid
	from TipoTransaccionCaja a, CCTransacciones b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Caja#">
	  and a.Ecodigo = b.Ecodigo 
	  and a.CCTcodigo = b.CCTcodigo
</cfquery>

<!--- Talonarios --->
<cfquery name="rsTalonarios" datasource="#Session.DSN#">
	select convert(varchar,Tid) as Tid, Tdescripcion, RIserie from Talonarios 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
</cfquery>

<!--- guarda el código de la lista de precios a utilizar --->
<cfset LPid = -1>

<cfset existeListaDefault = true>

<cfquery name="rsListaDefault" datasource="#Session.DSN#">
	select convert(varchar,LPid) as LPid 
	from EListaPrecios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and LPdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>

<!--- Si no hay lista default no puede ingresar transacciones --->
<cfif rsListaDefault.RecordCount EQ 0>			
	<cfset existeListaDefault = false>
</cfif>

<!--- Códigos de la Lista de Precios --->	
<cfquery name="rsListaPrecioSocios" datasource="#Session.DSN#">
	select convert(varchar,LPid) as LPid, SNcodigo 
	from ListaPrecioSocio
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<cfif modo NEQ "ALTA">

	<!--- Consulta del encabezado de la Transacción ---> 
	<cfquery name="rsTransaccion" datasource="#Session.DSN#">
			
		select 
			convert(varchar,FCid) as FCid, 
			convert(varchar,ETnumero) as ETnumero, 
			Ecodigo, 
			Ocodigo, 
			SNcodigo, 
			convert(varchar,Mcodigo) as Mcodigo, 
			ETtc, 
			CCTcodigo, 
			Icodigo, 
			convert(varchar,Ccuenta) as Ccuenta,
			convert(varchar,Tid) as Tid, 
			ETfecha, 
			ETtotal, 
			ETestado, 
			ETporcdes, 
			ETmontodes, 
			ETimpuesto, 
			ETnumext, 
			ETnombredoc, 
			ETobs,
			ETdocumento, 
			ETserie,
			(ETtotal - ETmontodes) as subtotal,
			ts_rversion		
		from ETransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">		
		  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
		  
	</cfquery>

	<!--- Nombre del Socio --->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNcodigo, SNidentificacion, SNnombre from SNegocios 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransaccion.SNcodigo#">
	</cfquery>

	<!--- Códigos de la Lista de Precios para este socio--->	
	<cfquery name="rsListaPrecioEsteSocio" datasource="#Session.DSN#">
		select convert(varchar,LPid) as LPid, SNcodigo 
		from ListaPrecioSocio
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransaccion.SNcodigo#">
	</cfquery>

	<!--- Si no tiene lista de precios busca si hay una lista Default para la empresa --->
	<cfif rsListaPrecioEsteSocio.RecordCount EQ 0>
		<cfif existeListaDefault>
			<cfset LPid = rsListaDefault.LPid>		
		</cfif>
	<cfelse>
		<cfset LPid = rsListaPrecioEsteSocio.LPid>		
	</cfif>
	
	<!--- Almacenes --->
	<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
		select distinct a.Alm_Aid, b.Bdescripcion from DListaPrecios a, Almacen b 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LPid#">
		  and a.Ecodigo = b.Ecodigo
		  and a.Alm_Aid = b.Aid
		order by b.Bdescripcion 		                                                                  
	</cfquery>

	<!--- Departamentos --->
	<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion from Departamentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Ddescripcion
	</cfquery>

	<!--- Vendedores --->
	<cfquery name="rsVendedores" datasource="#Session.DSN#">
		select convert(varchar,FVid) as FVid, FVnombre from FVendedores 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
	</cfquery>

	<!--- Cuentas por Concepto --->
	<cfquery name="rsCuentasConcepto" datasource="#Session.DSN#">
		select convert(varchar,a.Cid) as Cid, a.Dcodigo, 
			convert(varchar,a.Ccuenta) as Ccuenta,
			convert(varchar,a.Ccuentadesc) as Ccuentadesc 
		from CuentasConceptos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>	

			
	<cfif modoDet NEQ "ALTA">
	
		<!--- Detalle de la Línea --->
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select 
				convert(varchar,DTlinea) as DTlinea, 
				convert(varchar,FCid) as FCid, 
				convert(varchar,ETnumero) as ETnumero, 
				Ecodigo, 
				DTtipo, 
				convert(varchar,Aid) as Aid, 
				convert(varchar,Alm_Aid) as Alm_Aid, 
				convert(varchar,Ccuenta) as Ccuenta, 
				convert(varchar,Ccuentades) as Ccuentades, 
				convert(varchar,Cid) as Cid, 
				convert(varchar,FVid) as FVid,
				Dcodigo, 
				DTfecha, 
				DTcant, 
				DTpreciou, 
				DTdeslinea, 
				DTtotal, 
				DTborrado, 
				DTdescripcion, 
				DTdescalterna, 
				DTlineaext, 
				DTcodigoext, 
				ts_rversion		
			from DTransacciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DTlinea#">
			  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">		
			  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
		</cfquery>

	</cfif>

	<!--- Cuenta los artículos y los conceptos --->
	<cfquery name="rscArticulos" datasource="#Session.DSN#">
		select count(1) as cant from Articulos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rscConceptos" datasource="#Session.DSN#">
		select count(1) as cant from Conceptos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	
	var popUpWin=0; 
	
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function popUpWindowResizable(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	// Conlis ya sea de artículos o conceptos
	function doConlisItem() {
		if (document.form1.Item.value == "A")
			popUpWindow("ConlisArticulos.cfm?form=form1&id=Aid&desc=descripcion&Alm="+document.form1.Almacen.value
				+"&LPid="+document.form1.LPid.value,250,200,650,350);		
		if (document.form1.Item.value == "S")
			popUpWindow("ConlisConceptos.cfm?form=form1&id=Cid&desc=descripcion&depto="+document.form1.Dcodigo.value
			+"&LPid="+document.form1.LPid.value,250,200,650,350);
	}

	// validación de los campos del encabezado
	function valida() {
		var f = document.form1;
		if ('<cfoutput>#existeListaDefault#</cfoutput>' == 'false' && f.LPid.value == '') {
			alert('No existe lista de precios por defecto para esta empresa.');
			return false;
		}
		if (f.SNcodigo.value == "")		{
			alert ("Debe seleccionar el cliente ");
			f.SNnumero.focus();
			return false;
		}		
		if (f.CCTcodigo.value == "")		{
			alert ("Debe seleccionar el tipo de transacción ");
			f.CCTcodigo.focus();
			return false;
		}		
		if (f.FCid.value == "")		{
			alert ("Debe seleccionar la caja ");
			f.FCid.focus();
			return false;
		}
		if (f.ETnombredoc.value == "")		{
			alert ("Debe digitar el nombre de la transacción ");
			f.ETnombredoc.focus();
			return false;
		}				
		if (f.Mcodigo.value == "")		{
			alert ("Debe seleccionar la moneda ");
			f.Mcodigo.focus();
			return false;
		}
		var estado = f.ETtc.disabled;
		f.ETtc.disabled = false;								
		if (!validaNumero(qf(f.ETtc.value)))  {		
			alert("Debe digitar el tipo de cambio");
			f.ETtc.select();
			return false;
		}
		f.ETtc.disabled = estado;		
		if (new Number(f.ETtc.value) == 0) {
			alert("El tipo de cambio no puede ser cero");
			f.ETtc.select();
			return false;
		}
		if (f.Icodigo.value == "")		{
			alert ("Debe seleccionar el impuesto ");
			f.Icodigo.focus();
			return false;
		}
		if (f.ETobs.value == "")		{
			alert ("Debe digitar alguna observación ");
			f.ETobs.focus();
			return false;
		}
		if (!validaNumero(qf(f.Descuento.value)))  {		
			alert("Debe digitar el descuento");
			f.Descuento.select();
			return false;
		}				
		if (f.Ccuenta.value == "")		{
			alert ("No existe cuenta para esta caja. ");
			return false;
		}

		// quita las comas a los montos
		f.ETtc.disabled = false;						
		f.ETtc.value = qf(f.ETtc.value);
							
		f.ETporcdes.value = qf(f.ETporcdes.value);												
		f.ETmontodes.value = qf(f.ETmontodes.value);
		f.ETimpuesto.value = qf(f.ETimpuesto.value);						

		f.ETtotal.value = qf(f.ETtotal.value);		
		<cfif modo NEQ "ALTA"> return validaD(); </cfif>
		return true;
	}

	// validación de los campos del detalle
	function validaD() {
		var f = document.form1;
		
		if (f.Aid.value == "")  { 
			if (f.Cid.value == "")	{ 
				alert ("Debe digitar el concepto o artículo")            
				return false;
			}
			f.Aid.value = ''; 
		}																							 			   
		if (f.Cid.value == "")  { 
			if (f.Aid.value == ""){ 
				alert ("Debe digitar el concepto o artículo")            
				return false;
			}
			f.Cid.value = '';   
		}
		if (f.DTdescripcion.value == "" || f.DTdescripcion.value == " ") { 
			alert ("Debe digitar la descripción")
			f.DTdescripcion.focus()
			return false;
		} 				   
		
		if(f.Almacen.style.visibility == "visible"){
			if (f.Almacen.value == "")	{ 
				alert ("Debe digitar el almacén")                    
				return false;
			} 
		}
																																																											  
		//se debe validar la cuenta para todos los casos
		if (f.CcuentaDet.value == ""){ 
			alert ("Debe digitar la cuenta");                    
			return false;
		} 
		if (!validaNumero(qf(f.DTcant.value)))  {		
			alert("Debe digitar la cantidad");
			f.DTcant.select();
			return false;
		}												
		else
			f.DTcant.value =  qf(f.DTcant.value);
		
		if (f.DTcant.value == '0.00')  {
			alert("Debe digitar la cantidad mayor que cero");
			f.DTcant.select();
			return false;
		}
		
		if (!validaNumero(qf(f.DTpreciou.value)))  {		
			alert("Debe digitar el precio unitario mayor que cero");
			f.DTpreciou.select();
			return false;
		}												
		else
			f.DTpreciou.value =  qf(f.DTpreciou.value);
		
		if (f.DTpreciou.value == '0.00')  {
			alert("Debe digitar el precio unitario mayor que cero");
			f.DTpreciou.select();
			return false;
		}
		
		f.DTtotal.value = qf(f.DTtotal.value);											
		return true;	
	}

	function suma()	{
		var f = document.form1;
		//f.DTtotal.value = f.DTtotal.defaultValue;
		
		if (f.DTpreciou.value=="" ) f.DTpreciou.value = "0.00"
		if (f.DTdeslinea.value=="")f.DTdeslinea.value = "0.00"		
		if (f.DTcant.value=="" )f.DTcant.value = "0.00"
		
		if (f.DTpreciou.value=="-" ){
			f.DTpreciou.value = "0.00"
			f.DTtotal.value = "0.00"
		}    		
		
		if (f.DTdeslinea.value=="-"){    
			f.DTdeslinea.value = "0.00" 
			f.DTtotal.value = "0.00"
		}		
		
		if (f.DTcant.value=="-" ){
			f.DTcant.value = "0.00"
			f.DTtotal.value = "0.00"
		}    
				
		var cantidad = new Number(qf(f.DTcant.value))
		var precio = new Number(qf(f.DTpreciou.value))
		var descuento = new Number(qf(f.DTdeslinea.value))		
		var seguir = "si"
		
		if(cantidad < 0){
			f.DTcant.value="0.00"
			seguir = "no"
		}  
		
		if(precio < 0){
			f.DTpreciou.value="0.00"
			seguir = "no"
		} 
		
		if(descuento < 0){
			f.DTdeslinea.value="0.00"
			seguir = "no"
		}

		if(descuento > cantidad*precio){        
			f.DTdeslinea.value="0.00"
			f.DTtotal.value = cantidad * precio
		}
		else {        
			f.DTtotal.value = (cantidad * precio) - descuento
			f.DTtotal.value = fm(f.DTtotal.value,2)			
		}

	}
	
	function limpiarDetalle() {
		var f = document.form1;
		f.descripcion.value="";
		f.DTdescalterna.value="";            
		f.DTdescripcion.value="";                       
		f.Aid.value="";
		f.Cid.value="";
	}
	
	// cambia según el item que se escogió
	function cambiarDetalle(){		
		var f = document.form1;
		if(f.Item.value=="A"){
			f.DetalleItem.value="Articulo";
			f.DetalleItem.style.visibility="visible";
			f.descripcion.style.visibility="visible";
			document.getElementById("imgArticulo").style.visibility = "visible";
			f.Almacen.style.visibility = "visible";
			document.getElementById("AlmacenLabel").style.visibility = "visible";
		} 
		 
		if(f.Item.value=="S"){
			f.DetalleItem.value="Concepto";			
			f.DetalleItem.style.visibility="visible";			
			f.descripcion.style.visibility="visible";
			document.getElementById("imgArticulo").style.visibility = "visible";
			f.Almacen.style.visibility = "hidden";
			document.getElementById("AlmacenLabel").style.visibility = "hidden";
		}                
	  
	}      

	// limpia los campos según cambia el combo de almacenes
	function limpiarAxCombo() {
       var f = document.form1;   
	   f.Aid.value = "";
	   f.descripcion.value = "";
	   f.DTtipo.value = "S"; 	   
	   f.DTdescripcion.value = f.descripcion.value;
	}

	function Lista() {
		location.href = 'listaTransaccionesFA.cfm';
	}
	
	function Pagar() {
		popUpWindowResizable("PagosFA.cfm?form=form1&FCid="+document.form1.FCid.value+"&ETnumero="+document.form1.ETnumero.value,80,120,900,500);
	}

	function poneItem() {
        var f = document.form1;	
		if (f.Item.value == "A") f.DetalleItem.value = "Artículo";
		if (f.Item.value == "S") f.DetalleItem.value = "Concepto";
	}

	// En un hidden manda si se cambió o no los datos del encabezado, con el fin de saber si se debe actualizar el mismo
	function EncabezadoCambio() {
		var f = document.form1;
		f.CambioEncabezado.value = '0';

		if (f.Mcodigo.defaultValue != f.Mcodigo.value)  {
			f.CambioEncabezado.value = '1';
			return;
		}
		var estado = f.ETtc.disabled;
		f.ETtc.disabled = false;
		if (f.ETtc.defaultValue != f.ETtc.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		f.ETtc.disabled = estado;
		if (f.ETnombredoc.defaultValue != f.ETnombredoc.value) {
			f.CambioEncabezado.value = '1';
			return;
		}		
		if (f.ETobs.defaultValue != f.ETobs.value) {
			f.CambioEncabezado.value = '1';
			return;
		}		
		if (f.SNcodigo.defaultValue != f.SNcodigo.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.Icodigo.defaultValue != f.Icodigo.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.ETimpuesto.defaultValue != f.ETimpuesto.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.CCTcodigo.defaultValue != f.CCTcodigo.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.Descuento.defaultValue != f.Descuento.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		return false;
	}

	// Trae los datos asociados a la caja
	function TraerDatosCaja(caja) {			
		var f = document.form1;
		 <cfloop query="rsCajas">
		   if (caja == "<cfoutput>#rsCajas.FCid#</cfoutput>") {
				f.Ccuenta.value="<cfoutput>#rsCajas.Ccuenta#</cfoutput>"; 
				f.Ocodigo.value="<cfoutput>#rsCajas.Ocodigo#</cfoutput>"; 
		  }
		 </cfloop>					
	}
	
	// Sugiere el nombre del cliente en el campo del nombre del documento
	function AsignarNombre() {
		var f = document.form1;
		f.ETnombredoc.value = ''; 
		f.ETnombredoc.value = f.SNnombre.value;
		f.LPid.value = '';
		tieneListaPrecios(f.SNcodigo.value);
	}

	// Trae el número de talonario asociado a la transacción
	function TraerTransaccion(transaccion) {			
		var f = document.form1;
		 <cfloop query="rsTiposTransaccion">
		   if (transaccion == "<cfoutput>#rsTiposTransaccion.CCTcodigo#</cfoutput>") {
				f.Tid.value = "<cfoutput>#rsTiposTransaccion.Tid#</cfoutput>"; 
		  }
		 </cfloop>					
	}

	// Trae el número de Talonario de la transacción seleccionada
	function TraerTalonario(Tid) {			
		var f = document.form1;
		 <cfloop query="rsTalonarios">
		   if (Tid == "<cfoutput>#rsTalonarios.Tid#</cfoutput>") {
				f.ETserie.value="<cfoutput>#rsTalonarios.RIserie#</cfoutput>";
		  }
		 </cfloop>					
	}

	// Verifica si el socio tiene su lista de precios
	function tieneListaPrecios(socio) {			
		var f = document.form1;
		var esta = false;
		 <cfloop query="rsListaPrecioSocios">
		   if (!esta && socio == "<cfoutput>#rsListaPrecioSocios.SNcodigo#</cfoutput>") {
				f.LPid.value = "<cfoutput>#rsListaPrecioSocios.LPid#</cfoutput>"; 
				esta = true;
		  }
		 </cfloop>
		 return esta;		 					
	}

	// prepara algunos datos al hacer el post 
	function prepararDatos() {
		var f = document.form1;	
		f.DTtipo.value = f.Item.value; 
		var estado = f.ETtc.disabled; 
		f.ETtc.disabled = false; 
		if (valida()) {
			EncabezadoCambio();
			return true;
		} else {
			f.ETtc.disabled = estado; 
			f.ETimpuesto.value = fm(f.ETimpuesto.value,2);
			f.ETtotal.value = fm(f.ETtotal.value,2);										
			return false;
		}
	}	

	function Postear(){
		if (confirm('¿Desea aplicar este documento?')) {
			document.form1.ETtc.disabled = false;
			return true;
		} 
		else return false; 	
	}

</script>



<form name="form1" action="SQLTransaccionesFA.cfm" method="post">

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="7%"><div align="right"><font size="2"><strong>Caja:</strong></font></div></td>
      <td width="2%">&nbsp;</td>
      <td width="24%"><cfoutput> <strong><font size="2"><font color="##000099">#rsCajas.FCcodigo#&nbsp;</font></font></strong> 
          <input name="FCid" type="hidden" value="#rsCajas.FCid#">
        </cfoutput></td>
      <td width="1%">&nbsp;</td>
      <td width="8%"><div align="right">Transacci&oacute;n:</div></td>
      <td width="25%"><cfoutput> 
          <cfif modo NEQ "ALTA">
            <strong>#rsTiposTransaccion.CCTdescripcion#</strong> 
            <input type="hidden" name="CCTcodigo" value="#rsTiposTransaccion.CCTcodigo#">
            <cfelse>
            <select name="CCTcodigo" onChange="javascript: TraerTransaccion(this.value);">
              <cfloop query="rsTiposTransaccion">
                <option value="#rsTiposTransaccion.CCTcodigo#" <cfif modo NEQ 'ALTA' and rsTiposTransaccion.CCTcodigo EQ rsTransaccion.CCTcodigo>selected</cfif>>#rsTiposTransaccion.CCTdescripcion#</option>
              </cfloop>
            </select>
          </cfif>
        </cfoutput></td>
      <td width="0%" nowrap>&nbsp;</td>
      <td nowrap><cfoutput> 
          <cfif modo NEQ "ALTA">
            <strong><font size="2">Fact. <font color="##000099">#rsTransaccion.ETnumero#&nbsp;</font></font></strong> 
          </cfif>
        </cfoutput></td>
      <td colspan="2"><cfoutput> 
          <cfif modo NEQ "ALTA">
            <strong><font size="2">Trans. <font color="##000099">#rsTransaccion.ETdocumento##rsTransaccion.ETserie#</font></font></strong> 
          </cfif>
        </cfoutput></td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="right">Cliente:</div></td>
      <td>&nbsp;</td>
      <td> <cfoutput> 
          <cfif modo NEQ "ALTA">
            <strong><font color="##000099">#rsNombreSocio.SNnombre#</strong> 
            <input type="hidden" name="SNnombre" value="#rsNombreSocio.SNnombre#">
            <input type="hidden" name="SNcodigo" value="#rsTransaccion.SNcodigo#">
            <cfelse>
            <cf_sifsociosnegociosFA SNtiposocio="C" FuncJSalCerrar="AsignarNombre();"> 
          </cfif>
        </cfoutput></td>
      <td>&nbsp;</td>
      <td><div align="right">Moneda: </div></td>
      <td><cfif modo NEQ "ALTA">
          <cf_sifmonedas query="#rsTransaccion#" valueTC="#rsTransaccion.ETtc#" onChange="asignaTC();" FechaSugTC="#LSDateFormat(rsTransaccion.ETfecha,'DD/MM/YYYY')#" tabindex="1"> 
          <cfelse>
          <cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1"> 
        </cfif> <input name="Ocodigo" type="hidden" value="<cfoutput>#rsCajas.Ocodigo#</cfoutput>"></td>
      <td nowrap>&nbsp;</td>
      <td width="18%" nowrap> <div align="right">Tipo Cambio:</div></td>
      <td colspan="2"><input type="text" name="ETtc" style="text-align:right"size="10" maxlength="10" 
			onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
			onFocus="javascript:this.select();" 
			onChange="javascript: fm(this,4);"
			value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsTransaccion.ETtc,',9.0000')#</cfoutput></cfif>"> 
        <input name="Ccuenta" type="hidden" value="<cfoutput>#rsCajas.Ccuenta#</cfoutput>"> 
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="justify">Nombre en Documento:&nbsp;</div></td>
      <td>&nbsp;</td>
      <td><cfoutput> 
          <input name="ETnombredoc" type="text" value="<cfif modo NEQ 'ALTA'>#rsTransaccion.ETnombredoc#</cfif>" size="50" maxlength="255">
        </cfoutput> </td>
      <td>&nbsp;</td>
      <td><div align="right">Impuesto:</div></td>
      <td><select name="Icodigo" tabindex="1">
          <cfoutput query="rsImpuestos"> 
            <option value="#rsImpuestos.Icodigo#" <cfif modo NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsTransaccion.Icodigo>selected</cfif>>#rsImpuestos.Idescripcion#</option>
          </cfoutput> </select></td>
      <td nowrap>&nbsp;</td>
      <td nowrap><div align="right">SubTotal:</div></td>
      <td colspan="2"> <cfoutput> <input name="subtotal" type="text" style="text-align:right;" 
			onChange="javascript: fm(this,2);" class="cajasinbordeb" readonly tabindex="-1" 
			value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsTransaccion.subtotal,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18"></td>
      <td>&nbsp;</td>
      <td width="1%"></cfoutput></tr>
    <tr> 
      <td rowspan="2"><div align="right">Observaci&oacute;n:</div></td>
      <td rowspan="2" >&nbsp;</td>
      <td rowspan="2" > <cfoutput> 
          <textarea name="ETobs" cols="35" rows="3" id="ETobs"><cfif modo NEQ 'ALTA'>#rsTransaccion.ETobs#</cfif></textarea>
        </cfoutput></td>
      <td rowspan="2" >&nbsp;</td>
      <td colspan="2" rowspan="2"> <cfoutput> 
          <fieldset>
          <legend><strong>Descuento</strong></legend>
          <label> 
          <input name="chkPorcentaje" type="radio" value="radio" 
				onClick="javascript:document.form1.chkMonto.checked = false; calculaDescuento()" checked>
          Porcentaje</label>
          &nbsp; 
          <input name="Descuento" type="text" size="12" tabindex="1" maxlength="12" style="text-align:right" 
				onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
				onFocus="javascript:this.select();" 
				onChange="javascript: fm(this,2); calculaDescuento();" 
				value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse>#LSCurrencyFormat(rsTransaccion.ETporcdes,'none')#</cfif>">
          <input type="hidden" name="ETporcdes" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsTransaccion.ETporcdes,'none')#<cfelse>0.00</cfif>">
          <input type="hidden" name="ETmontodes" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsTransaccion.ETmontodes,'none')#<cfelse>0.00</cfif>">
          <br>
          <label> 
          <input type="radio" name="chkMonto" 
				onClick="javascript:document.form1.chkPorcentaje.checked = false; calculaDescuento()" value="radio">
          Monto</label>
          </fieldset>
        </cfoutput> </td>
      <td rowspan="2" nowrap>&nbsp;</td>
      <td height="32" nowrap> <div align="right">Impuesto:</div></td>
      <td colspan="2"> <input type="text" name="ETimpuesto" style="text-align:right" 
			onChange="javascript: fm(this,2);" class="cajasinbordeb" readonly tabindex="-1" 
			value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsTransaccion.ETimpuesto,'none')#</cfoutput><cfelse>0.00</cfif>" size="18" maxlength="18"></td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap><div align="right"><strong>Total:</strong></div></td>
      <td colspan="2"> <cfoutput> 
          <input name="ETtotal" type="text" style="text-align:right;" 
			onChange="javascript: fm(this,2);" class="cajasinbordeb" readonly tabindex="-1" 
			value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsTransaccion.ETtotal,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18">
        </cfoutput></td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11"> <cfoutput> 
          <input type="hidden" name="ETfecha" value="<cfif modo NEQ "ALTA">#LSDateFormat(rsTransaccion.ETfecha,'DD/MM/YYYY')#<cfelse>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfif>">
          <input type="hidden" name="ETestado" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETestado#<cfelse>P</cfif>">
          <input type="hidden" name="ETnumext" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETnumext#</cfif>">
          <input type="hidden" name="ETnumero" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETnumero#</cfif>">
          <input type="hidden" name="Tid" value="<cfif modo NEQ "ALTA">#rsTransaccion.Tid#</cfif>">
          <input type="hidden" name="ETserie" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETserie#</cfif>">
          <input type="hidden" name="ETdocumento" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETdocumento#</cfif>">
          <input type="hidden" name="LPid" value="">
          <!--- ts_rversion --->
          <cfset tsE = "">
          <cfif modo neq "ALTA">
            <cfinvoke 
				 component="sif.Componentes.DButils"
				 method="toTimeStamp"
				 returnvariable="tsE">
              <cfinvokeargument name="arTimeStamp" value="#rsTransaccion.ts_rversion#"/>
            </cfinvoke>
          </cfif>
          <input type="hidden" name="timestampE" value="<cfif modo NEQ 'ALTA'><cfoutput>#tsE#</cfoutput></cfif>">
        </cfoutput> <div align="center"> 
          <cfif modo EQ "ALTA">
            <div align="center"> 
              <input name="AgregarE" tabindex="1" type="submit" value="Agregar" 
			  	onClick="javascript: if (valida()) 										
										return true;
									else { 
										var f = document.form1;
										f.ETimpuesto.value = fm(f.ETimpuesto.value,2);
										f.ETtotal.value = fm(f.ETtotal.value,2);
										return false;
									}">
              <input type="button" tabindex="1" name="Regresar" value="Regresar" onClick="javascript:Lista();">
            </div>
          </cfif>
        </div></td>
    </tr>
  </table>

<cfif rsTiposTransaccion.RecordCount GT 0> 
	<script language="JavaScript1.2">
		TraerTransaccion(document.form1.CCTcodigo.value);
		TraerTalonario(document.form1.Tid.value);
	</script>
</cfif>

<!--- Detalle de la Transacción --->   
<cfif modo NEQ "ALTA">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr> 
        <td colspan="12" class="tituloAlternoPeq"><div align="center">Detalle 
            de la Transacción</div></td>
      </tr>
      <tr> 
        <td><div align="right">Item:</div></td>
        <td><select name="Item" onChange="javascript:limpiarDetalle();cambiarDetalle();" tabindex="2">
            <cfif rscArticulos.cant GT 0>
              <option value="A" <cfif modoDet NEQ "ALTA" and rsLinea.DTtipo EQ "A">selected</cfif>>Art&iacute;culo</option>
            </cfif>
            <cfif rscConceptos.cant GT 0>
              <option value="S" <cfif modoDet NEQ "ALTA" and rsLinea.DTtipo EQ "S">selected</cfif>>Concepto</option>
            </cfif>
          </select> </td>
        <td> <label id="AlmacenLabel">Almacén:</label></td>
        <td><select name="Almacen" onChange="javascript:limpiarAxCombo();" tabindex="2">
            <cfoutput query="rsAlmacenes"> 
              <option value="#rsAlmacenes.Alm_Aid#" <cfif modoDet NEQ "ALTA" and rsAlmacenes.Alm_Aid EQ rsLinea.Alm_Aid>selected</cfif>>#rsAlmacenes.Bdescripcion#</option>
            </cfoutput> </select></td>
        <td><input name="DetalleItem" type="text" class="cajasinbordeb" tabindex="-1" value="Artículo" size="8"></td>
        <td nowrap> <input name="descripcion" type="text" tabindex="-1" 
			onChange="javascript: alert('concepto');" 
			value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DTdescripcion#</cfoutput></cfif>" size="40" maxlength="40" readonly> 
          <a href="#" tabindex="-1"><img id="imgArticulo" src="../../imagenes/Description.gif" alt="Lista" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisItem();"></a></td>
        <td colspan="4"><div align="right"> </div></td>
        <td><div align="right">Cantidad:</div></td>
        <td><input name="DTcant" onFocus="javascript:document.form1.DTcant.select();" type="text" tabindex="3" style="text-align:right" onChange="javascript:fm(this,2);suma();" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTcant,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18"></td>
      </tr>
      <tr> 
        <td height="36"> <div align="right">&nbsp;Descripci&oacute;n:</div></td>
        <td colspan="3"><input name="DTdescripcion" tabindex="2" onFocus="javascript:document.form1.DTdescripcion.select();" type="text" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DTdescripcion#</cfoutput></cfif>" size="50" maxlength="255"></td>
        <td>Desc. Alterna:</td>
        <td colspan="5"><input name="DTdescalterna" tabindex="2" onFocus="javascript:document.form1.DTdescalterna.select();" type="text" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DTdescalterna#</cfoutput></cfif>" size="40" maxlength="255"> 
          <div align="right"></div></td>
        <td nowrap> <div align="right">Precio Unitario:</div></td>
        <td><input name="DTpreciou" onFocus="javascript:document.form1.DTpreciou.select();" type="text" tabindex="3" style="text-align:right" onChange="javascript:fm(this,2);suma();" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTpreciou,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18"></td>
      </tr>
      <tr> 
        <td><label id="DcodigoLabel">Departamento:</label></td>
        <td colspan="3">
			
			<select name="Dcodigo" tabindex="2" 
			onChange="javascript: TraerCuentaConcepto(document.form1.Cid.value,this.value);">
            <cfoutput query="rsDepartamentos"> 
              <option value="#rsDepartamentos.Dcodigo#" <cfif modoDet NEQ "ALTA" and rsDepartamentos.Dcodigo EQ rsLinea.Dcodigo>selected</cfif>>#rsDepartamentos.Ddescripcion#</option>
            </cfoutput> 
			</select>
			
			</td>
        <td><div align="right">Vendedor:</div></td>
        <td colspan="5"><select name="FVid" tabindex="1">
            <cfoutput query="rsVendedores"> 
              <option value="#rsVendedores.FVid#" <cfif modoDet NEQ 'ALTA' and rsVendedores.FVid EQ rsLinea.FVid>selected</cfif>>#rsVendedores.FVnombre#</option>
            </cfoutput> </select></td>
        <td><div align="right">Descuento:</div></td>
        <td><input name="DTdeslinea" onFocus="javascript: this.select();" type="text" tabindex="3" style="text-align:right" onChange="javascript:fm(this,2);suma();" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTdeslinea,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18"></td>
      </tr>
      <tr> 
        <td><div align="right">&nbsp;</div></td>
        <td colspan="3">&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="5">&nbsp;</td>
        <td><div align="right"><strong>Total:</strong></div></td>
        <td><input name="DTtotal" type="text" class="cajasinbordeb" style="text-align:right" onchange="javascript:fm(this,2);" tabindex="-1" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18" readonly> 
          <cfoutput> 
            <input name="Cid" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Cid#</cfif>">
            <input name="Aid" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Aid#</cfif>">
            <input name="DTtipo" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTtipo#</cfif>">
            <input name="DTfecha" type="hidden" value="<cfif modoDet NEQ "ALTA">#LSDateFormat(rsLinea.DTfecha,'DD/MM/YYYY')#<cfelse>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfif>">
            <input name="DTlinea" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTlinea#</cfif>">
            <input name="CcuentaDet" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Ccuenta#</cfif>">
            <input name="CcuentadesDet" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Ccuentades#</cfif>">
            <input name="DTlineaext" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTlineaext#</cfif>">
            <input name="DTcodigoext" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTcodigoext#</cfif>">
            <input name="CambioEncabezado" type="hidden" value="">
            <!--- ts_rversion del Detalle --->
            <cfset tsD = "">
            <cfif modoDet NEQ "ALTA">
              <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD">
              </cfinvoke>
            </cfif>
            <input name="timestampD" type="hidden" value="<cfif modoDet NEQ "ALTA">#tsD#</cfif>">
          </cfoutput></td>
      </tr>
      <tr> 
        <td colspan="12"><div align="center"> 
            <cfif modoDet EQ "ALTA">
              <input name="AgregarD" tabindex="3" type="submit" value="Agregar" 
			  	onclick="javascript: return prepararDatos()">
              <cfelse>
              <input name="CambiarD" tabindex="3" type="submit" value="Cambiar" 
			  	onClick="javascript: return prepararDatos()">
              <input name="BorrarD" tabindex="3" type="submit" value="Borrar Linea" onclick="javascript:if (confirm('¿Desea borrar esta línea del documento?')) return true; else return false;">
            </cfif>
            <input name="BorrarE" tabindex="3" type="submit" value="Borrar Documento" onclick="javascript:if (confirm('¿Desea borrar este documento?')) return true; else return false;">
            <input type="submit" tabindex="3" name="Aplicar" value="Aplicar" onClick="javascript:return Postear();">
            <input type="button" tabindex="3" name="ListaE" value="Regresar" onClick="javascript:Lista();">
						<input type="button" tabindex="3" name="Pagos" value="Pagar" onClick="javascript:Pagar();">
          </div></td>
      </tr>
    </table>
	
	<script language="JavaScript1.2" type="text/javascript">
		// Trae la cuenta asociada al concepto
		function TraerCuentaConcepto(concepto,depto) {			
			var f = document.form1;
			 <cfloop query="rsCuentasConcepto">
			   if (depto == "<cfoutput>#rsCuentasConcepto.Dcodigo#</cfoutput>" 
			   && concepto == "<cfoutput>#rsCuentasConcepto.Cid#</cfoutput>" ) {
					f.CcuentaDet.value="<cfoutput>#rsCuentasConcepto.Ccuenta#</cfoutput>";
					f.CcuentadesDet.value="<cfoutput>#rsCuentasConcepto.Ccuentadesc#</cfoutput>";					 
			  }
			 </cfloop>					
		}
	
	</script>
	
</cfif>  

</form>

<script language="JavaScript1.2">

	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {	
	
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			formatCurrency(document.form1.TC,2);
			document.form1.ETtc.disabled = true;			
		}
		else
			document.form1.ETtc.disabled = false;							
		var estado = document.form1.ETtc.disabled;
		document.form1.ETtc.disabled = false;
		document.form1.ETtc.value = document.form1.TC.value;
		document.form1.ETtc.disabled = estado;
	
	}

	// Valida y calcula el descuento ya sea por el monto o por el porcentaje
	function calculaDescuento() {
		var f = document.form1;
		var desc = new Number(qf(f.Descuento.value));
		var total = new Number(qf(f.ETtotal.value));
		
		if (f.chkPorcentaje.checked) {					
			if (desc > 100) {
				alert('Debe digitar un porcentaje entre 0 y 100%');
				f.Descuento.select();
				return false;
			} 
			else {
				f.ETporcdes.value = desc;
				f.ETmontodes.value = (total * desc) / 100;
				return true;
			}
		}
		else {
			f.ETmontodes.value = desc;
			if (total != 0)	
				f.ETporcdes.value = (desc * 100) / total;
			else
				f.ETporcdes.value = 0.00;
			return true;		
		} 
		return true;
	}

	// Inicializa el Tipo de cambio
	function validatcLOAD()
	{                      		  
	  <cfif modo EQ "ALTA">
			if (document.form1.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")	{
				document.form1.ETtc.value = "1.0000";                                
				document.form1.ETtc.disabled = true;
			}  
			else {
				document.form1.Mcodigo.value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>";
				document.form1.ETtc.value = "1.0000";
				document.form1.ETtc.disabled = true;                    
			} 
	   <cfelse>
			if (document.form1.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")
				document.form1.ETtc.disabled = true;
			else
				document.form1.ETtc.disabled = false;
	   </cfif>   

	}   
	
</script>

<script language="JavaScript1.2" type="text/javascript">
	var f = document.form1;
	f.LPid.value = '<cfoutput>#LPid#</cfoutput>';
	validatcLOAD();
	<cfif modo NEQ "ALTA">
		asignaTC();
	<cfelse>
		var estado = f.ETtc.disabled;
		f.ETtc.disabled = false;
		f.ETtc.value = f.TC.value;
		f.ETtc.disabled = estado;		
	</cfif>
	
	<cfif modo NEQ "ALTA">
		poneItem();
		cambiarDetalle();
	<cfelse>
		f.SNnumero.focus();
	</cfif>

</script>
