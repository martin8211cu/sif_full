
<body  bgcolor="#eeeeee">
<cf_templatecss>
<style type="text/css">
	body{padding: 20px;color: #222;text-align: center;
		font: 85% "Trebuchet MS",Arial,sans-serif}
	h1,h2,h3,p{margin:0;padding:0;font-weight:normal}
	p{padding: 0 10px 15px}
	h1{font-size: 120%;color:#3366CC;letter-spacing: 1px}
	hr{color: black;}
	h2{font-size: 140%;line-height:1;color:#002455 }
	div#container{margin: 0 auto;padding:5px;text-align:left;background:#FFFFFF}
	
	div#IZQ{float:right;width:250px;padding:10px 0;margin:5px 0;background: #eeeeee;  }
	div#DER{float:right;width:250px;padding:10px 0;margin:5px 0;background: #EEEEEE; }
	div#CENTRO_ARRIBA{float:left;width:470px;padding:10px 0;margin:5px 0;background:#FF9933;}
	div#CENTRO_CENTRO{float:left;width:470px;padding:10px 0;margin:5px 0;background: #FFD154;}
	div#CENTRO_ABAJO{clear:both;width:470px;background: #C4E786;padding:5px 0;}
</style>
<cfsilent>
    <cfquery name="qryIZQ" datasource="asp">
    select  a.SPorden,
            a.SPcodigo,
            a.SPdescripcion as name,
            a.SPhomeuri as dir, 
            c.SMNtitulo,
            b.SMNcodigoPadre,
            b.SMNorden,
            b.SMNcolumna
            from SProcesos a
            inner join SMenues b
                on  a.SScodigo = b.SScodigo
                and	a.SMcodigo = b.SMcodigo
                and	a.SPcodigo = b.SPcodigo
                
            inner join SMenues c 	
                on  c.SMNcodigo = b.SMNcodigoPadre
                and c.SMNtitulo in ('Administración','Control de Marcas','Trámites','Control Activos','Otros')
            where a.SScodigo = 'RH'
             and a.SMcodigo = 'AUTO'
             and a.SPmenu = 0
            and  b.SMNcodigoPadre is not null
            and a.SPcodigo  in (
                    select b.SPcodigo from SProcesosRol a
                       inner join SProcesos b
                        on a.SPcodigo = b.SPcodigo
                        and b.SPmenu = 0
                        where SRcodigo in (
                        select SRcodigo
                        from UsuarioRol
                        where SRcodigo like '%AUTO%'
                      and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                      and SScodigo = 'RH'
                      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSdc#">
                    )
                )
    
			<!--- lizandrada para Coopelesca --->
			<!--- se requiere mostrar el proceso de registro de incidencias en autogestion (pq aki no se), pero este se asigno al rol
				  REGINC (rol con solo ese proceso), pues es solo para algunos empleados (asistentes del planillero). 
				  Entonces se hace este remiendo para incluir el proceso en este query.
			--->
			union
			
			select  c.SPorden,
					c.SPcodigo,
					c.SPdescripcion as name,
					c.SPhomeuri as dir, 
					'Administración',
					null as SMNcodigoPadre,
					900 as SMNorden,
					1 as SMNcolumna
 
			from UsuarioRol a, SProcesosRol b, SProcesos c
			where a.SRcodigo = 'RegInc' <!--- nombre del rol, DEBE TENER ESTE NOMBRE --->
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSdc#">
			and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and a.SScodigo='RH'
			and b.SScodigo=a.SScodigo
			and b.SRcodigo=a.SRcodigo
			and c.SScodigo=b.SScodigo
			and c.SMcodigo=b.SMcodigo
			and c.SPcodigo=b.SPcodigo

			order by 5
    </cfquery>
</cfsilent>
 <cfoutput>
    <cfset list1 = " ,.,á,é,í,ó,ú,>,<,ñ,(,)">
    <cfset list2 = "_,_,a,e,i,o,u,,n,_,_">
    <cfset var_menu = "">
    <cfset corte = "">
    <table width="100%" border="0" cellpadding="1"  cellspacing="1">
         <cfloop query="qryIZQ">
           <cfif corte neq  qryIZQ.SMNtitulo>
                    <cfset var_menu = trim(qryIZQ.SMNtitulo)>
                    <cfset var_menu = 'MENU_' & ReplaceList(trim(var_menu),list1,list2)>
                    
                    <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="#var_menu#"
                    Default="#trim(qryIZQ.SMNtitulo)#"
                    returnvariable="#var_menu#"/>                       		

                <cfset corte = qryIZQ.SMNtitulo>
                 <tr>
                    <td valign="top" colspan="2">
                       <h1>#Evaluate(var_menu)#</h1>
                    </td>
                </tr>
           </cfif>
            <tr>
                <td valign="top">
                   <font class="imagen_sistema">&##9658;</font>
                </td>
                <td valign="top">
                    <cfset var_menu = trim(qryIZQ.name)>
                    <cfset var_menu = 'MENU_' & ReplaceList(trim(var_menu),list1,list2)>
                    
                    <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="#var_menu#"
                    Default="#trim(qryIZQ.name)#"
                    returnvariable="#var_menu#"/>
                    <a  onClick="javascript:ir_a('/cfmx#qryIZQ.dir#')" style=" font-size:11px; cursor:pointer">#Evaluate(var_menu)#</a>
                </td>
            </tr>
        </cfloop>
     </table>
</cfoutput>

<script type="text/javascript">
	function ir_a(url){
		parent.location.href=url;
	}
</script>

