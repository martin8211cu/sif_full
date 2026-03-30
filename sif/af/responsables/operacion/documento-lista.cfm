<!--- centros de custodia que tengo a cargo  --->
<cfquery name="rsCCADmin" datasource="#Session.Dsn#">
	select distinct cc.CRCCid
	from UsuarioReferencia ur
		inner join CRCentroCustodia cc
		on ur.llave = <cf_dbfunction name="to_char" args="cc.DEid">
		
	where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">  <!--- codigo de mi usuario --->
	  and ur.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ecodigosdc#"> <!--- ecodigosdc --->
	  and ur.STabla    = 'DatosEmpleado'
	  and cc.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">    <!--- Centros de custodia de la empresa en la que estoy firmado --->
</cfquery>

<cfif rsCCADmin.recordcount gt 0>
	<cfset CCADmin = ValueList(rsCCADmin.CRCCid)>
<cfelse>
	<cfset CCADmin = '-1'>
</cfif>
 
<!--- centros de custodia en donde soy usuario --->
 <cfquery name="rsCCUSer" datasource="#Session.Dsn#">
	Select b.CRCCid  
	from CRCCUsuarios b
	where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
 </cfquery>

<cfif rsCCUSer.recordcount gt 0>
	<cfset CCUsuarios = ValueList(rsCCUSer.CRCCid)>
<cfelse>
	<cfset CCUsuarios = '-1'>
</cfif>

<cfquery name="rsCRTipoDocumento" datasource="#Session.Dsn#">
	select b.CRTDid as value, <cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo),' - ',rtrim(b.CRTDdescripcion)"> as description, 0 ord, b.CRTDcodigo
		from CRTipoDocumento b
	 where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	union 
	select -1 as value, '--Todos--' as description, -1 as ord, ' ' as CRTDcodigo
		from dual
	order by 3,4
</cfquery>

<!--- 
	En el query principal me va traer todos los documentos que yo como usuario he creado en los diferentes centros de custodia 
	y el query seguido del union me trae todos los documentos del centro de custodia del cual soy el administrador
--->

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo) ,' - ' ,rtrim(b.CRTDdescripcion)"  returnvariable="CRTipoDocumento">
<cf_dbfunction name="concat" args="rtrim(DEidentificacion) ,'-' ,rtrim(d.DEapellido1),' ',rtrim(d.DEapellido2),' ' ,rtrim(d.DEnombre)"  returnvariable="DatosEmpleado" >
<cf_dbfunction name="concat" args="rtrim(f.CRCCcodigo),' - ', rtrim(f.CRCCdescripcion)"  returnvariable="CRCentroCustodia" >
<cfinvoke 
	component="sif.Componentes.pListas" 
	method="pLista" 
	returnvariable="Lvar_Lista" 
	columnas="a.CRDRid, a.CRTDid, a.CRTCid, a.DEid, a.CRDRfdocumento, a.CRCCid, 
			#PreserveSingleQuotes(CRTipoDocumento)# as CRTipoDocumento,
			#PreserveSingleQuotes(DatosEmpleado)#   as DatosEmpleado,
			a.CRDRdocori,(select EOnumero from DOrdenCM where DOlinea = a.DOlinea) as OCnumero,
			#PreserveSingleQuotes(CRCentroCustodia)# as CRCentroCustodia, rtrim(a.CRDRplaca) as CRDRplaca, g.Usulogin, a.Monto, ' ' as e"
	tabla="CRDocumentoResponsabilidad a 
			inner join CRCentroCustodia f
				on f.CRCCid = a.CRCCid
			inner join Usuario g
				on g.Usucodigo = a.BMUsucodigo
			left outer join CRTipoDocumento b 
				on b.CRTDid = a.CRTDid
			left outer join DatosEmpleado d
				on d.DEid = a.DEid"
	filtro="a.Ecodigo=#Session.Ecodigo#
	      and CRDRestado = 0 
	      and CRDR_TipoReg is null  
		  and 
		  ( 
		  	   ( a.CRCCid  in (#CCUsuarios#) and a.BMUsucodigo  = #Session.Usucodigo#) 
			or ( a.CRCCid  in (#CCADmin#))
		  ) 	
		  order by a.CRDRid"
	desplegar="CRTipoDocumento,DatosEmpleado,CRDRplaca,Usulogin,CRDRfdocumento,CRDRdocori,OCnumero,Monto,e"
	etiquetas="Tipo de Documento, Empleado, Placa,Usuario,Fecha,Doc,OC,Monto, "
	filtrar_por="a.CRTDid,#PreserveSingleQuotes(DatosEmpleado)#,a.CRDRplaca, g.Usulogin, a.CRDRfdocumento,
	a.CRDRdocori,(select EOnumero from DOrdenCM where DOlinea = a.DOlinea),a.Monto,''"
	cortes="CRCentroCustodia"
	formatos="S,S,S,S,D,S,S,UM, U"
	align="left,left,left,left,left,left,left,right,left"
	mostrar_filtro="true"
	filtrar_automatico="true"
	rscrtipodocumento="#rsCRTipoDocumento#"
	showemptylistmsg="true"
	MaxRowsQuery="125"
	emptylistmsg=" --- No se encontraron documentos --- "
	ira="#CurrentPage#"
	botones="Nuevo,Aplicar,Eliminar,Recuperar,Importar"
	checkboxes="S"
	keys="CRDRid"
	ajustar="N"
/>


<script language="javascript" type="text/javascript">
	
		function algunoMarcado(){
			var f = document.lista;
			if (f.chk) {
				if (f.chk.value) {
					return true;
				} else {
					for (var i=0; i<f.chk.length; i++) {
						if (f.chk[i].checked) { 
							return true;
						}
					}
				}
			}
			return false;
		}
		function funcAplicar(){
			if (algunoMarcado()){
				if (confirm("Desea procesar los elementos seleccionados?")){
					document.lista.action="documento-sql.cfm";
					return true;
				}
			} else {
				alert("Debe seleccionar los elementos de la lista que desea procesar!");
			}
			return false;
		}
		
		function funcEliminar(){
			if (algunoMarcado()){
				if (confirm("Desea eliminar los elementos seleccionados?")){
					document.lista.action="documento-sql.cfm";
					return true;
				}
			} else {
				alert("Debe seleccionar los elementos de la lista que desea eliminar!");
			}
			return false;
		}		
		function funcImportar(){
			document.lista.action="/cfmx/sif/af/importar/ImportarResponsabilidad.cfm";
			return true;
		}	
		
		function funcRecuperar(){
			document.lista.action="documentoAplicados.cfm";
			return true;
		}
		document.lista.filtro_CRTipoDocumento.focus();
</script>
