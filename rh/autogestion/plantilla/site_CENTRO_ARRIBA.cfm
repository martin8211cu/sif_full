
<body  bgcolor="#e6eef5">
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
	
	div#IZQ{float:right;width:250px;padding:10px 0;margin:5px 0;background: #DAE6FE;  }
	div#DER{float:right;width:250px;padding:10px 0;margin:5px 0;background: #EEEEEE; }
	div#CENTRO_ARRIBA{float:left;width:470px;padding:10px 0;margin:5px 0;background:#FF9933;}
	div#CENTRO_CENTRO{float:left;width:470px;padding:10px 0;margin:5px 0;background: #FFD154;}
	div#CENTRO_ABAJO{clear:both;width:470px;background: #C4E786;padding:5px 0;}
</style>
<cfsilent>
    <cfquery name="qryCENT_ARRIBA" datasource="asp">
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
                and c.SMNtitulo ='Gestión del Talento'
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
    
            order by a.SPorden,c.SMNtitulo,a.SPcodigo, a.SPdescripcion
    </cfquery>
    <cfset list1 = " ,.,á,é,í,ó,ú,>,<,ñ,(,)">
    <cfset list2 = "_,_,a,e,i,o,u,,n,_,_">
    <cfset var_menu = "">
    <cfset corte = "">    
</cfsilent>
 <cfoutput>
    <table width="100%" border="0" cellpadding="1"  cellspacing="1">
         <cfloop query="qryCENT_ARRIBA">
			<cfif qryCENT_ARRIBA.currentrow eq 1 or qryCENT_ARRIBA.currentrow mod 2>
                <tr>
                    <td valign="top">
                       <font class="imagen_sistema">&##9658;</font>
                    </td>
                    <td valign="top">
                        <cfsilent>
                        <cfset var_menu = trim(qryCENT_ARRIBA.name)>
                        <cfset var_menu = 'MENU_' & ReplaceList(trim(var_menu),list1,list2)>
                        
                        <cfinvoke component="sif.Componentes.Translate"
                        method="Translate"
                        Key="#var_menu#"
                        Default="#trim(qryCENT_ARRIBA.name)#"
                        returnvariable="#var_menu#"/>
                        </cfsilent>
                        <a   onClick="javascript:ir_a('/cfmx#qryCENT_ARRIBA.dir#')" style="font-size:11px; cursor:pointer">#Evaluate(var_menu)#</a>
                    </td>
				<cfelse>
                    <td valign="top">
                       <font class="imagen_sistema">&##9658;</font>
                    </td>
                    <td valign="top">
                        <cfsilent>
                        <cfset var_menu = trim(qryCENT_ARRIBA.name)>
                        <cfset var_menu = 'MENU_' & ReplaceList(trim(var_menu),list1,list2)>
                        
                        <cfinvoke component="sif.Componentes.Translate"
                        method="Translate"
                        Key="#var_menu#"
                        Default="#trim(qryCENT_ARRIBA.name)#"
                        returnvariable="#var_menu#"/>
                        </cfsilent>
                        <a   onClick="javascript:ir_a('/cfmx#qryCENT_ARRIBA.dir#')" style="font-size:11px; cursor:pointer">#Evaluate(var_menu)#</a>
                    </td>
                 </tr>
            </cfif>
       </cfloop>
     </table>
</cfoutput>
<script type="text/javascript">
	function ir_a(url){
		parent.location.href=url;
	}
</script>