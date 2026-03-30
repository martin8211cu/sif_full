<body  bgcolor="#EEEEEE">

<style type="text/css">
	body{padding: 20px;color: #222;text-align: center;
		font: 85% "Trebuchet MS",Arial,sans-serif}
	h1,h2,h3,p{margin:0;padding:0;font-weight:normal}
	p{padding: 0 10px 15px}
	h1{font-size: 80%;color:#3366CC;letter-spacing: 1px}
	hr{color: black;}
	h2{font-size: 140%;line-height:1;color:#002455 }
	div#container{margin: 0 auto;padding:5px;text-align:left;background:#FFFFFF}
	
	div#IZQ{float:right;width:250px;padding:10px 0;margin:5px 0;background: #DAE6FE;  }
	div#DER{float:right;width:250px;padding:10px 0;margin:5px 0;background: #EEEEEE; }
	div#CENTRO_ARRIBA{float:left;width:470px;padding:10px 0;margin:5px 0;background:#FF9933;}
	div#CENTRO_CENTRO{float:left;width:470px;padding:10px 0;margin:5px 0;background: #FFD154;}
	div#CENTRO_ABAJO{clear:both;width:470px;background: #C4E786;padding:5px 0;}
</style>
<cfsilent>
    <cfquery name="rsAvisos" datasource="#session.dsn#">
        select 	a.IdNoticia, a.FechaNoticia,b.DescCategoria,a.Titulo,Contenido,RutaImagen 
        from EncabNoticias a
			inner join CategoriaNoticias b
				on a.IdCategoria = b.IdCategoria
			inner join DetNoticias c
				on a.IdNoticia = c.IdNoticia
        where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo #">
			and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between a.FechaDesde and a.FechaHasta
			and a.Activa  = '1'
			and a.Tipo = '2'
        order by a.IdCategoria,a.Titulo,a.Orden
    </cfquery>
</cfsilent>
<cfset corte = "">  

<!----Buscar el DEid correspondiente al usuario conectado a la aplicacion---->
<cfquery name="rsDEid" datasource="#session.DSN#">
	select llave as DEid
	from UsuarioReferencia
	where STabla = 'DatosEmpleado'
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<!----========= Funcion verifca que el usuario conectado este en el cfuncional seleccionado o tenga el puesto seleccionado en la noticia =========---->
<cffunction name="funcVisualiza" output="true" returntype="boolean">
	<cfargument name="DEid" 		type="numeric" 	required="no" default="-1">
	<cfargument name="IdNoticia" 	type="numeric" 	required="yes">

	<cfset vb_visualizacf = true>
	<cfset vb_visualizapt = true>
	<cfset vb_visualiza = true>	
	<!----CENTROS FUNCIONALES---->
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFid
		from DetUsuariosNoticias
		where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IdNoticia#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CFid is not null
	</cfquery>
	<cfset CFids = ValueList(rsCFuncional.CFid)>
	<!----PUESTOS---->
	<cfquery name="rsPuestos" datasource="#session.DSN#">
		select ltrim(rtrim(RHPcodigo)) as RHPcodigo
		from DetUsuariosNoticias
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IdNoticia#">
			and RHPcodigo is not null
	</cfquery>
	<cfset Puestos = QuotedValueList(rsPuestos.RHPcodigo)>
	
	<cfif len(trim(arguments.DEid)) and arguments.DEid NEQ -1>
		<cfif len(trim(CFids))><!---Si se han definido cfuncionales se verifica ke el usuario pertenezca a ese cfuncional---->
			<cfquery name="rsEstaEnCFuncional" datasource="#session.DSN#">			
				select c.CFid
				from LineaTiempo a
					inner join RHPlazas b
						on a.RHPid = b.RHPid
					inner join CFuncional c
						on b.CFid = c.CFid	
						and c.CFid in (#CFids#)
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			</cfquery>
			<cfif rsEstaEnCFuncional.RecordCount EQ 0><!---No pertenece a ningun centro funcional seleccionado---->
				<cfset vb_visualizacf = false>			
			</cfif>
		</cfif>
				
		<cfif len(trim(Puestos))><!---Si se ha definido puestos se verifika ke el usuario pertenezca al puesto---->
			<cfquery name="rsEsPuesto" datasource="#session.DSN#">				
				select b.RHPcodigo
				from LineaTiempo a
					inner join RHPuestos b
						on a.RHPcodigo= b.RHPcodigo
						and a.Ecodigo = b.Ecodigo
						and b.RHPcodigo in (#PreserveSingleQuotes(Puestos)#)
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">  between a.LTdesde and a.LThasta
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			</cfquery>
			<cfif rsEsPuesto.RecordCount EQ 0><!---No pertenece a ningun puesto seleccionado--->
				<cfset vb_visualizapt = false>			
			</cfif>
		</cfif>
		<cfif len(trim(CFids)) and len(trim(Puestos))><!---Se definieron cfuncionales y puestos--->
			<cfif not vb_visualizacf or not vb_visualizapt>
				<cfset vb_visualiza = false>
			</cfif>
		<cfelseif len(trim(CFids)) and not vb_visualizacf><!---Se definio UNO de los dos y NO aplica---->
			<cfset vb_visualiza = false>
		<cfelseif len(trim(Puestos)) and not vb_visualizapt>
			<cfset vb_visualiza = false>
		</cfif>
	<cfelse><!---Si el usuario no es empleado y no se han definido cfuncionales ni puestos--->
		<cfif len(trim(CFids)) NEQ 0 or len(trim(Puestos)) NEQ 0>
			<cfset vb_visualiza = false>
		</cfif>
	</cfif><!----Fin de si existe el DEid---->
		
	<cfreturn vb_visualiza>
</cffunction>

<table width="100%" border="0" cellpadding="0"  cellspacing="0">
    <cfoutput>
    <cfloop query="rsAvisos">
        <!---Verificar si la noticia es visible al usuario--->       
	     <cfset vb_ver = true>		
		<cfif rsDEid.RecordCount NEQ 0 and len(trim(rsDEid.DEid))>
			<cfset vb_ver = funcVisualiza(rsDEid.DEid,rsAvisos.IdNoticia)>			
		<cfelse>
			<cfset vb_ver = funcVisualiza(-1,rsAvisos.IdNoticia)>			
		</cfif>			
		<cfif vb_ver><!---Si el sitio es visible para el usuario---->
			<cfif corte neq  rsAvisos.DescCategoria>
				<cfset corte = rsAvisos.DescCategoria>
				<tr>
					<td valign="top" colspan="2">
					   <h1>#corte#</h1>
					</td>
				</tr>		
			</cfif>
			<tr>
				<td valign="top">
					<cfif isdefined("rsAvisos.RutaImagen") and len(trim(rsAvisos.RutaImagen)) and rsAvisos.RutaImagen neq 'Ninguna'>
						<img  height="25px" width="25px" src="#rsAvisos.RutaImagen#">
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td valign="top">
					<cfif isdefined("rsAvisos.Contenido") and len(trim(rsAvisos.Contenido))>
						#rsAvisos.Contenido#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2">
					<hr>
				</td>
			</tr>
		</cfif>
    </cfloop>
    </cfoutput>
</table>

