package models.kisrhombille;

class KSegment {

    public var from:KPoint;
    public var to:KPoint;

    public function new(_from:KPoint, _to:KPoint){
        from = _from;
        to = _to;
        //validate?
    }

    public function validate(){

        //we need to check that the line between the two _valid_ verticies only crosses over our Kisrhombille tesselation edges.
    }
}