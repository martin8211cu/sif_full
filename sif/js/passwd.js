// Validacion de la contraseña (lado del cliente)


// distancia minima entre dos hileras, se usa para validar el password
// http://www.csse.monash.edu.au/~lloyd/tildeAlgDS/Dynamic/Edit.html
function DPA(s1, s2){ 
   var m = new Array();
   var i, j;
   for(i=0; i < s1.length + 1; i++) m[i] = new Array(); // i.e. 2-D array

   m[0][0] = 0; // boundary conditions

   for(j=1; j <= s2.length; j++)
      m[0][j] = m[0][j-1]-0 + 1; // boundary conditions

   for(i=1; i <= s1.length; i++)                            // outer loop
   { m[i][0] = m[i-1][0]-0 + 1; // boundary conditions

      for(j=1; j <= s2.length; j++)                         // inner loop
       { var diag = m[i-1][j-1];
         if( s1.charAt(i-1) != s2.charAt(j-1) ) diag++;

         m[i][j] = Math.min( diag,               // match or change
                   Math.min( m[i-1][j]-0 + 1,    // deletion
                             m[i][j-1]-0 + 1 ) ) // insertion
       }//for j
    }//for i

   return m[s1.length][s2.length];
 }//DPA

function letrasYNumeros (s){
    var letras = false, numeros = false, i;
    for (i = 0; i < s.length; i++) {
        var ch = s.charAt(i);
        letras  |= (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z');
        numeros |= (ch >= '0' && ch <= '9');
        if (letras && numeros) return true;
    }
    return false;
}

// regresa null si el password es valido, de lo contrario, regresa el mensaje de error
function validarPassword (user, pass){
    var msg = null;
         
    if (pass.length < 6) {
        msg = "La contraseña debe medir al menos seis caracteres.";
    } 
	else if (!letrasYNumeros (pass)) {
        msg = "La contraseña debe contener letras y números.";
    } 
	else if (user == pass) {
        msg = "El usuario y la contraseña no deben coincidir.";
    } 
	else if (user.indexOf(pass) != -1) {
        msg = "La contraseña no puede ser parte del usuario.";
    } 
	else if (pass.indexOf(user) != -1) {
        msg = "El usuario no puede ser parte de la contraseña.";
    } 
	else if (DPA(user,pass) < 4) {
        msg = "La contraseña no puede ser tan parecida al usuario.";
    }
    return msg;
}