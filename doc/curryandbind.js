/*      Javascript Curry
 *  f(n,m) --> f'(n)(m)
 */

var fn_multiply = (n,m) => (n*m);
var fn_multiply10 = (m) => fn_multiply(10,m) ;
console.log( 'fn_multiply(2,4): ',fn_multiply(2,4) );
console.log( 'fn_multiply10(4): ',fn_multiply10(4) );
console.log(
