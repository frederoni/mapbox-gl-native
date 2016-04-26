#ifndef MBGL_FILL_LAYER
#define MBGL_FILL_LAYER

#include <mbgl/layer/layer_impl.hpp>
#include <mbgl/layer/fill_layer.hpp>
#include <mbgl/layer/fill_layer_properties.hpp>

namespace mbgl {

class FillLayer::Impl : public Layer::Impl {
public:
    std::unique_ptr<Layer> clone() const override;

    void parseLayout(const JSValue&) override {};
    void parsePaints(const JSValue&) override;

    void cascade(const StyleCascadeParameters&) override;
    bool recalculate(const StyleCalculationParameters&) override;

    std::unique_ptr<Bucket> createBucket(StyleBucketParameters&) const override;

    float getQueryRadius() const override;
    bool queryIntersectsGeometry(
            const GeometryCollection& queryGeometry,
            const GeometryCollection& geometry,
            const float bearing,
            const float pixelsToTileUnits) const override;

    FillPaintProperties paint;
};

} // namespace mbgl

#endif
