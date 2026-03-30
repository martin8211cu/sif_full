<!--- 
	Me muestra una lista de usuarios en donde aparecen mi usuario y la lista
	de los usuarios que pertenenece al centro de custodia que tengo acargo.		
 --->
<cfquery name="rsUsuarios" datasource="#Session.Dsn#">
	select U.Usucodigo,U.Usulogin  , 2 as indice
	from Usuario U
	inner join CRCCUsuarios UC
		on U.Usucodigo = UC.Usucodigo
<!---		and UC.CRCCid in (
		Select b.CRCCid
		from UsuarioReferencia  a
		inner join CRCentroCustodia b
		on a.llave =  <cf_dbfunction name="to_char" args="b.DEid">
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">         <!---ecodigo normal--->
		where STabla = 'DatosEmpleado'
		and a.Usucodigo   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">  <!---codigo  de mi usuario--->
		and a.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ecodigosdc#">) <!---ecodigosdc--->
--->		where U.Usucodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		and UC.CRCCid in (
		Select b.CRCCid
		from UsuarioReferencia  a
		inner join CRCentroCustodia b
		on a.llave =  <cf_dbfunction name="to_char" args="b.DEid">
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">         <!---ecodigo normal--->
		where STabla = 'DatosEmpleado'
		and a.Usucodigo   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">  <!---codigo  de mi usuario--->
		and a.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ecodigosdc#">) <!---ecodigosdc--->
	union
	select #session.Usucodigo# as Usucodigo, '#session.Usulogin#' as  Usulogin, 1 as indice
		from dual
	order by indice,Usulogin	
</cfquery>
<cfif rsUsuarios.recordcount gt 0>
	<cfset ListaUser = ValueList(rsUsuarios.Usucodigo)>
<cfelse>
	<cfset ListaUser = '-1'>
</cfif>

<!--- Centros de custodia que tengo acargo  --->
 <cfquery name="rsCCADmin" datasource="#Session.Dsn#">
 	Select b.CRCCid
	from UsuarioReferencia  a
	inner join CRCentroCustodia b
	on a.llave =  <cf_dbfunction name="to_char" args="b.DEid">
	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	where STabla = 'DatosEmpleado'
	and a.Usucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
	and a.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigosdc#">
 </cfquery>
<cfif rsCCADmin.recordcount gt 0>
	<cfset CCADmin = ValueList(rsCCADmin.CRCCid)>
<cfelse>
	<cfset CCADmin = '-1'>
</cfif>
 
<!--- Centros de custodia en donde soy usuario --->
 <cfquery name="rsCCUSer" datasource="#Session.Dsn#">
	Select a.CRCCid  from CRCentroCustodia  a
		inner   join  CRCCUsuarios b on b.CRCCid = a.CRCCid and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
 </cfquery>

<cfif rsCCUSer.recordcount gt 0>
	<cfset CCUsuarios = ValueList(rsCCUSer.CRCCid)>
<cfelse>
	<cfset CCUsuarios = '-1'>
</cfif>

<!--- Tipos de Documentos --->
<cfquery name="rsCRTipoDocumento" datasource="#Session.Dsn#">
	select <cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo) ,' - ',rtrim(b.CRTDdescripcion)"> as value, <cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo) ,' - ',rtrim(b.CRTDdescripcion)"> as description, 0, b.CRTDcodigo
	from CRTipoDocumento b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	union select '' as value, '--Todos--' as description, -1, ' ' 
		from dual
	order by 3,4
</cfquery>

<!--- 
	En el query principal me va traer todos los documentos que yo como usuario he creado
	en los diferentes centros de custodia y el query seguido del union me trae todos los 
	documentos del centro de custodia del cual soy el administrador      
--->
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO --->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION --->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>

<!--- Lista Principal para mostrar los documentos Aplicados. --->
<cf_dbfunction name="concat" args="rtrim(b.CRTDcodigo) ,' - ',rtrim(b.CRTDdescripcion)" returnvariable="CRTipoDocumento">
<cf_dbfunction name="concat" args="rtrim(DEidentificacion) ,'-' ,rtrim(d.DEapellido1) ,' ' ,rtrim(d.DEapellido2),' ' ,rtrim(d.DEnombre)" returnvariable="DatosEmpleado">
<cf_dbfunction name="concat" args="rtrim(f.CRCCcodigo) ,' - ',rtrim(f.CRCCdescripcion)" returnvariable="CRCentroCustodia">
<cfinvoke 
	component="sif.Componentes.pListas" 
	method="pLista" 
	returnvariable="Lvar_Lista" 
	columnas=" 	a.CRDRid, 
				a.CRTDid, 
				a.CRTCid, 
				a.DEid, 
				a.CRDRfdocumento, 
				a.CRCCid,
				coalesce((select #PreserveSingleQuotes(CRTipoDocumento)#
							from CRTipoDocumento b 
						  where a.CRTDid = b.CRTDid ), 'Tipo No definido')  as CRTipoDocumento,
				#PreserveSingleQuotes(DatosEmpleado)# as DatosEmpleado,
				#PreserveSingleQuotes(CRCentroCustodia)# as CRCentroCustodia,
				rtrim(a.CRDRplaca) as CRDRplaca,
				a.CRDRdocori,(select EOnumero from DOrdenCM where DOlinea = a.DOlinea) as OCnumero,
				Usulogin as Usulogin,
				case when a.CRDRutilaux = 1 then a.CRDRid else -1 end as valor,
				case when a.CRDRutilaux = 1 then 'Sistema Auxiliar' else '' end as Estado " 
	tabla=" CRDocumentoResponsabilidad a
				inner join CRCentroCustodia f 
					on a.CRCCid = f.CRCCid
				inner join DatosEmpleado d 
					on a.DEid = d.DEid 
				left outer join Usuario u 
	   				on u.Usucodigo = a.BMUsucodigo "
	filtro=" a.Ecodigo=#Session.Ecodigo# and CRDRestado = 10
 				and exists( select 1 
							from CRCCUsuarios g 
							where g.Usucodigo = #session.Usucodigo#
								and g.CRCCid = a.CRCCid)
			order by a.CRDRid"
	desplegar="CRTipoDocumento,DatosEmpleado,CRDRplaca,Usulogin,CRDRfdocumento,CRDRdocori,OCnumero,Estado"
	etiquetas="Tipo de Documento, Empleado, Placa,Login,Fecha,Doc,OC,x"
	filtrar_por="	a.CRTDid, 
					#PreserveSingleQuotes(DatosEmpleado)#,
					a.CRDRplaca,
					Usulogin,
					a.CRDRfdocumento,CRDRdocori,
					(select EOnumero from DOrdenCM where DOlinea = a.DOlinea),
					'' "
	cortes="CRCentroCustodia"
	formatos="S,S,S,S,D,S,S,US"
	align="left,left,left,left,left,left,left,left"
	mostrar_filtro="true"
	filtrar_automatico="true"
	rscrtipodocumento="#rsCRTipoDocumento#"
	showemptylistmsg="true"
	MaxRowsQuery="125"
	emptylistmsg=" --- No se encontraron documentos --- "
	ira="#CurrentPage#"
	botones="Digitados, Recuperar"
	checkboxes="S"
	keys="CRDRid"
	inactivecol="valor"
	ajustar="N"
/>

<script language="javascript" type="text/javascript">
	<!--//
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
		
	function funcRecuperar(){
		if (algunoMarcado()){
			if (confirm("Desea recuperar los elementos seleccionados?")){
				document.lista.action="documentoAplicados-sql.cfm";
				return true;
			}
		} else {
			alert("Debe seleccionar los elementos de la lista que desea procesar!");
		}
		return false;
	}
				
	function funcDigitados(){
		document.lista.action="documento.cfm";
		return true;
	}

	document.lista.filtro__CRTipoDocumento.focus();
	//-->
</script>