
<form name="form1" action="index2.cfm" method="post">
	<table>
    	<tr>
        	<td>
            	Usuario
            </td>
            <td>
            	<input name="Usulogin" type="text" value="gustavof"/>
            </td>
        </tr>        
    	<tr>
        	<td>
            	Password
            </td>
            <td>
            	<input name="Password" type="text" value=""/>
                <input name="HashMethod" type="hidden" value="MD5" />
            </td>
        </tr>
        <tr>
        	<td>CEcodigo</td>
        	<td>
            	<input name="CEcodigo" type="text" value="" />
            </td>
        </tr>
        <tr>
        	<td>
            	<input name="submit" value="enviar" type="submit" />
            </td>
        </tr>
    </table>
</form>

<cfif isdefined("form.Password")>
    <cfquery datasource="asp" name="password_query">
        select
            a.Hash, a.HashMethod, a.PasswordSalt,
            b.Usulogin, b.CEcodigo, a.AllowedAccess
        from UsuarioPassword a 
            inner join Usuario b
            on a.Usucodigo = b.Usucodigo
        where b.Usulogin = '#form.Usulogin#'
        and CEcodigo = #form.CEcodigo#
    </cfquery>
    <cfdump var="#password_query#">
    
    <cfset seg()>

    	<cffunction name="seg" access="public" output="yes" returntype="any">
            <cfset hash1 = hashPassword(form.HashMethod,form.password,form.Usulogin,form.CEcodigo,password_query.PasswordSalt)>
        </cffunction>
        
        
		<cffunction name="hashPassword" access="public" returntype="string" output="yes">
            <cfargument name="hashMethod"   type="string"  required="yes">
            <cfargument name="passwd"     type="string"  required="yes">
            <cfargument name="uid"          type="string"  required="yes">
            <cfargument name="CEcodigo"     type="numeric" required="yes">
            <cfargument name="passwdSalt" type="string"  required="yes">
            
            <cfif Arguments.CEcodigo GT 1>
                <!--- este if existe para que los passwords que migremos del framework viejo sirvan --->
                <cfset Arguments.uid = Arguments.uid & '##' & CEcodigo>
            </cfif>
            <cfset instr = Arguments.passwd & "$$" & Arguments.uid & "$$" & Arguments.passwdSalt>
            <cfdump var="#instr#"><br />
            <cfreturn __hash( instr, Arguments.hashMethod )>
        </cffunction>
        
        <cffunction name="__hash" access="public" returntype="string" output="false">
            <cfargument name="data"       type="string" required="yes">
            <cfargument name="hashMethod" type="string" required="yes">
    
            <cfset md = CreateObject("java", "java.security.MessageDigest")>
            <cfset md = md.getInstance(Arguments.hashMethod)>
            <cfdump var="#Arguments.data.getBytes()#">
            <cfset md.update(Arguments.data.getBytes())>
            <cfreturn __decodeHexStr( md.digest() )>
        </cffunction>
        
        <cffunction name="__decodeHexStr" access="public" returntype="string" output="false">
            <cfargument name="byte_array" type="any" required="true">
            
            <cfset var Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f")>
            <cfset var miarreglo=#ListtoArray(ArraytoList(#arguments.byte_array#,","),",")#>
            <cfset var arreglo_ret=ArrayNew(1)>
    
            <cfif not isArray(arguments.byte_array)>
                <cfreturn "">
            </cfif>
    
            <cfloop index="i" from="1" to="#ArrayLen(miarreglo)#">
                <cfif miarreglo[i] LT 0>
                    <cfset miarreglo[i]=miarreglo[i]+256>
                </cfif>
                <cfif miarreglo[i] LT 16>
                    <cfset arreglo_ret[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
                <cfelse>
                    <cfset arreglo_ret[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
                </cfif>
            </cfloop>
            <cfreturn ArraytoList(arreglo_ret,"")>
        </cffunction>
    
        <cfoutput>Hash Actual de BD .............: #password_query.Hash#</cfoutput><br />
        <cfoutput>Hash del password digitado: #hash1#</cfoutput><br />
        <cfoutput>Password digitado: #form.Password#</cfoutput>
</cfif>



<!--- El siguiente código sirve para punto de ventas --->
<!--- NO SUBIR!!! Gustavo Fonseca!!!--->
<!--- <cfset LvarAlgoritmo = 'AES'>
<cfset password = url.pass>

<!--- http://10.7.7.78:8300/cfmx/home/public/index2.cfm?pass='8945c92b7bc69a368c7b1d250e7' --->
<cfoutput>#password#</cfoutput>
<cfset LvarPassword =decrypt(trim(password),'gE1/S/pwxkjLcTwjV4t6rQ==',LvarAlgoritmo,'Hex')>
El password es:<cfoutput>#LvarPassword#</cfoutput>
<cfabort>
 --->