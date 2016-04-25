#ifndef MBGL_LAYOUT_PROPERTY
#define MBGL_LAYOUT_PROPERTY

#include <mbgl/style/property_value.hpp>
#include <mbgl/style/property_parsing.hpp>
#include <mbgl/style/property_evaluator.hpp>
#include <mbgl/util/rapidjson.hpp>

#include <utility>

namespace mbgl {

template <typename T>
class LayoutProperty {
public:
    explicit LayoutProperty(T v)
        : value(std::move(v)),
          defaultValue(value) {}

    const PropertyValue<T>& get() const {
        return currentValue;
    }

    void set(const PropertyValue<T>& value_) {
        currentValue = value_;
    }

    void parse(const char * name, const JSValue& layout) {
        if (layout.HasMember(name)) {
            currentValue = parseProperty<T>(name, layout[name]);
        }
    }

    void calculate(const StyleCalculationParameters& parameters) {
        if (currentValue) {
            PropertyEvaluator<T> evaluator(parameters, defaultValue);
            value = PropertyValue<T>::visit(currentValue, evaluator);
        }
    }

    // TODO: remove / privatize
    operator T() const { return value; }
    T value;

private:
    T defaultValue;
    PropertyValue<T> currentValue;
};

} // namespace mbgl

#endif
